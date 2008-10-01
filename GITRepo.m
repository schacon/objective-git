//
//  GITRepo.m
//  ObjectiveGit
//
//  Created by chapbr on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GITRepo.h"
#import "NSFileManager-DirHelpers.h"
#import "NSDataCompression.h"
#include <CommonCrypto/CommonDigest.h>

#define IS_APLHA(n)	(n <= 102 && n >= 97) ? 1 : 0

int gitUnpackHex (const unsigned char *rawsha, char *sha1)
{
	static const char hex[] = "0123456789abcdef";
	int i;
	
	for (i = 0; i < 20; i++) {          
		unsigned char n = rawsha[i];
		sha1[i * 2] = hex[((n >> 4) & 15)];
		n <<= 4;
		sha1[(i * 2) + 1] = hex[((n >> 4) & 15)];
	}
	sha1[40] = '\0';
	
	return 1;   
}


/*
 * fills 20-char sha from 40-char hex version
 */

int gitPackHex (const char *sha1, unsigned char *rawsha)
{
	unsigned char byte = 0;
	int i, j = 0;
	
	for (i = 1; i <= 40; i++) {
		unsigned char n = sha1[i - 1];
		
		if(IS_APLHA(n)) {
			byte |= ((n & 15) + 9) & 15;
		} else {
			byte |= (n & 15);
		}
		if(i & 1) {
			byte <<= 4;
		} else {
			rawsha[j] = (byte & 0xff);
			j++;
			byte = 0;
		}
	}
	return 1;
}


@implementation GITRepo

@synthesize path;
@synthesize workingDir;
@synthesize bare;

- (id) initWithPath:(NSString *) gitDir bare:(BOOL) bareRepo error:(NSError **) error; 
{
	if (![super init])
		return nil;
	
	[self setBare:bareRepo];
	
	NSString *gitPath = [gitDir stringByStandardizingPath];
	NSString *dotGitPath = [gitPath stringByAppendingPathComponent:@".git"];
	
	// normal git repo in repo/.git
	if ([NSFileManager directoryExistsAtPath:dotGitPath]) {
		[self setWorkingDir:gitPath];
		[self setPath:dotGitPath];
		[self setBare:NO];
		return self;
	}
	
	// bare repo: repo.git
	if ([NSFileManager directoryExistsAtPath:gitPath] &&
		([gitPath pathExtension] == @"git" || bareRepo)) {
		[self setPath:gitPath];
		[self setBare:YES];
		return self;
	}
	
	// repo needs to be initialized
	if (![NSFileManager fileExistsAtPath:gitPath]) {
		if ([self createGitRepoAtPath:gitPath error:error]) {
			[self setPath:gitPath];
			[self setBare:YES];
			return self;
		} else {
			return nil;
		}
	}
	
	// raise error: Invalid Git Repo
	
	return nil;
}

- (id) initWithPath:(NSString *) gitDir;
{
	return [self initWithPath:gitDir error:nil];
}

- (id) initWithPath:(NSString *) gitDir error:(NSError **) error;
{
	return [self initWithPath:gitDir bare:NO error:error];
}

- (void) dealloc;
{
	[path release];
	[workingDir release];
	[super dealloc];
}

// For now, only creates a 'bare' repo.
// Similar to executing 'git clone --bare'

// Utility methods for creating git subdirs
- (BOOL) createGitSubDir:(NSString *) subPath error:(NSError **) error;
{
	NSString *gitPath = [[self path] stringByAppendingString:subPath];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL success = [fm createDirectoryAtPath:gitPath
				 withIntermediateDirectories:YES 
								  attributes:nil
									   error:error];
	return success;
}


- (BOOL) createGitRepoAtPath:(NSString *) gitDir error:(NSError **) error;
{
	BOOL createdDirs, wroteConfig, wroteHead = NO;
	
	createdDirs = [self createGitSubDir:@"refs" error:error] &&
				  [self createGitSubDir:@"refs/heads" error:error] &&
				  [self createGitSubDir:@"refs/tags" error:error] &&
				  [self createGitSubDir:@"objects" error:error] &&
				  [self createGitSubDir:@"objects/info" error:error] &&
				  [self createGitSubDir:@"objects/pack" error:error] &&
				  [self createGitSubDir:@"branches" error:error] &&
				  [self createGitSubDir:@"hooks" error:error] &&
				  [self createGitSubDir:@"info" error:error];
	
	if (createdDirs) {
		NSString *config = @"[core]\n\t"
		@"repositoryformatversion = 0\n\t"
		@"filemode = true\n\t"
		@"bare = true\n\t"
		@"logallrefupdates = true\n";
		NSString *configFile = [gitDir stringByAppendingPathComponent:@"config"];

		NSString *head = @"ref: refs/heads/master\n";
		NSString *headFile = [gitDir stringByAppendingPathComponent:@"HEAD"];
			
		wroteConfig = [config writeToFile:configFile 
							   atomically:YES 
								 encoding:NSUTF8StringEncoding 
								    error:error];
		wroteHead = [head writeToFile:headFile 
						   atomically:YES 
							 encoding:NSUTF8StringEncoding 
								error:error];
	}
	
	return createdDirs && wroteConfig && wroteHead;
}		

// KVC accessors for refs
- (NSUInteger) countOfRefs { return [[self refs] count]; }

- (id) objectInRefsAtIndex:(NSUInteger) i;
{
	return [[self refs] objectAtIndex:i];
}
// end KVC accessors

- (NSString *) refsPath;
{
	return [[self path] stringByAppendingPathComponent:@"refs"];
}

- (NSArray *) refs;
{
	NSMutableArray *refs = [[NSMutableArray alloc] init];
	
	NSString *tempRef, *thisSha;
	NSString *refsPath = [self refsPath];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([NSFileManager directoryExistsAtPath:refsPath]) {
		NSEnumerator *e = [[fm subpathsAtPath:refsPath] objectEnumerator];
		NSString *thisRef;
		while ( (thisRef = [e nextObject]) ) {
			tempRef = [refsPath stringByAppendingPathComponent:thisRef];
			thisRef = [@"refs" stringByAppendingPathComponent:thisRef];
			
			if ([NSFileManager directoryExistsAtPath:tempRef]) {
				thisSha = [[NSString alloc] stringWithContentsOfFile:tempRef
															encoding:NSASCIIStringEncoding 
															   error:nil];
				[refs addObject:[NSArray arrayWithObjects:thisRef,thisSha,nil]];
				[thisSha release];
				
				if([thisRef isEqualToString:@"refs/heads/master"]) {
					[refs addObject:[NSArray arrayWithObjects:@"HEAD",thisSha,nil]];
					[thisSha release];
				}
			}
		}
	}
	NSArray *refsCopy = [[refs copy] autorelease];
	[refs release];
	
	return refsCopy;
}

- (BOOL) updateRef:(NSString *)refName toSha:(NSString *)toSha error:(NSError **)error;
{
	NSString *refPath = [[self path] stringByAppendingPathComponent:refName];
	return [toSha writeToFile:refPath atomically:YES encoding:NSUTF8StringEncoding error:error];
}

- (ObjGitCommit *) commitFromSha:(NSString *)sha1;
{
	ObjGitObject *obj = [self objectFromSha:sha1];
	ObjGitCommit *commit = [[ObjGitCommit alloc] initFromGitObject:obj];
	return [commit autorelease];
}

- (ObjGitObject *) objectFromSha:(NSString *)sha1;
{
	NSString *objectPath = [self looseObjectPathBySha:sha1];
	//NSLog(@"READ FROM FILE: %@", objectPath);
	NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:objectPath];
	ObjGitObject *obj = [[ObjGitObject alloc] initFromRaw:[fh availableData] withSha:sha1];
	return [obj autorelease];	
}

- (NSMutableArray *) commitsFromSha:(NSString *)shaValue limit:(NSUInteger)commitSize;
{
	BOOL unlimited = (commitSize == 0); 
	NSString *currentSha = shaValue;
	
	NSMutableArray *toDoArray = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray *commitArray = [NSMutableArray arrayWithCapacity:commitSize];
	ObjGitCommit *gCommit;
	
	[toDoArray addObject: currentSha];
	
	// loop for commits	
	while( ([toDoArray count] > 0) && (unlimited || ([commitArray count] < commitSize)) ) {
		currentSha = [[toDoArray objectAtIndex: 0] retain];
		[toDoArray removeObjectAtIndex:0];
		
		gCommit = [self commitFromSha:currentSha];
		
		[toDoArray addObjectsFromArray:gCommit.parentShas];
		[commitArray addObject:gCommit];
	}

	return commitArray;
}

- (BOOL) hasObject: (NSString *)sha1;
{
	NSString *objPath;
	objPath = [self looseObjectPathBySha:sha1];

	if ([NSFileManager fileExistsAtPath:objPath]) {
		return YES;
	} else {
		// TODO : check packs
	}
	return NO;
}

- (NSString *) looseObjectPathBySha: (NSString *)shaValue;
{
	NSString *looseSubDir   = [shaValue substringWithRange:NSMakeRange(0, 2)];
	NSString *looseFileName = [shaValue substringWithRange:NSMakeRange(2, 38)];
	
	NSString *dir = [NSString stringWithFormat: @"%@/objects/%@", [self path], looseSubDir];
	
	NSFileManager *fm = [NSFileManager defaultManager];

	if (! [NSFileManager directoryExistsAtPath:dir]) {
		[fm createDirectoryAtPath:dir attributes:nil];
	}
	
	return [NSString stringWithFormat: @"%@/objects/%@/%@", [self path], looseSubDir, looseFileName];
}

// Maybe this go into GitObject...?
- (NSString *) writeObject:(NSData *)objectData withType:(NSString *)type size:(NSUInteger)size;
{
	NSMutableData *object;
	NSString *header, *objectPath, *shaStr;
	unsigned char rawsha[20];
	
	header = [NSString stringWithFormat:@"%@ %d", type, size];	
	object = [[header dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];
	
	[object appendData:objectData];
	
	CC_SHA1([object bytes], [object length], rawsha);
	
	// write object to file
	shaStr = [self unpackSha1Hex:rawsha];
	objectPath = [self looseObjectPathBySha:shaStr];
	//NSData *compress = [[NSData dataWithBytes:[object bytes] length:[object length]] compressedData];
	NSData *compressedData = [object compressedData];
	
	BOOL success = [compressedData writeToFile:objectPath atomically:YES];
	[object release];
	
	// return a string? Should probably return a BOOL to indicate that file has been written...
	return shaStr;
}

/*
 * returns 1 if the char is alphanumeric, 0 if not 
 */
+ (int) isAlpha:(unsigned char)n;
{
	return IS_APLHA(n);
}

/*
 * fills a 40-char string with a readable hex version of 20-char sha binary
 */
+ (int) gitUnpackHex:(const unsigned char *)rawsha fillSha:(char *)sha1;
{
	return gitUnpackHex(rawsha, sha1);
}

+ (NSString *) unpackSha1Hex:(const unsigned char *)rawsha;
{
	NSString *sha1String = nil;
	char sha1[41];
	
	int success = gitUnpackHex(rawsha, sha1);
	if (success) {
		sha1[40] = '\0';
		sha1String = [NSString stringWithCString:sha1 encoding:NSASCIIStringEncoding];
	}
		
	return sha1String;
}


+ (int) gitPackHex:(const char *)sha1 fillRawSha:(unsigned char *)rawsha;
{
	return gitPackHex(sha1, rawsha);
}

@end