//
//  GITCommit.m
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GITCommit.h"

@implementation GITCommit

@synthesize	parentShas;
@synthesize author;
@synthesize committer;
@synthesize treeSha;
@synthesize message;
@synthesize gitObject;

- (id) initFromGitObject:(ObjGitObject *)gObject {
	if (! [super init])
		return nil;

	[self setGitObject:gObject];
	[self parseContent];
	return self;
}

- (id) initFromRaw:(NSData *)rawData withSha:(NSString *)shaValue
{
	ObjGitObject *gObj = [[[ObjGitObject alloc] initFromRaw:rawData withSha:shaValue] autorelease];
	return [self initFromGitObject:gObj];
}

- (void) dealloc;
{
	[parentShas release];
	[author release];
	[committer release];
	[treeSha release];
	[message release];
	[gitObject release];
	[super dealloc];
}

- (void) logObject
{
	NSLog(@"tree     : %@", treeSha);
	NSLog(@"author   : %@, %@ : %@", 
		  [author valueForKey:@"name"], [author valueForKey:@"email"], [author valueForKey:@"date"]);
	NSLog(@"committer: %@, %@ : %@",
		  [committer valueForKey:@"name"], [committer valueForKey:@"email"], [committer valueForKey:@"date"]);
	NSLog(@"parents  : %@", parentShas);
	NSLog(@"message  : %@", message);
}

- (NSString *) sha;
{
	NSString *objectSha = [[[self gitObject] sha] copy];
	return [objectSha autorelease];
}

- (void) setAuthor:(NSDictionary *)newAuthor;
{
	if (author != newAuthor) {
		[author release];
		author = [newAuthor mutableCopy];
	}
}

- (void) setCommitter:(NSDictionary *)newAuthor;
{
	if (committer != newAuthor) {
		[committer release];
		committer = [newAuthor mutableCopy];
	}
}

- (NSArray *) authorArray 
{
	return [author objectsForKeys:[NSArray arrayWithObjects:@"name", @"email", @"date", nil]
											 notFoundMarker:[NSNull null]];
}

- (void) parseContent
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// extract parent shas, tree sha, author/committer info, message
	NSString *contents = [[self gitObject] contents];
	NSArray	*lines = [contents componentsSeparatedByString:@"\n"];
	NSMutableArray *parents = [NSMutableArray new];
	NSMutableArray *buildMessage = [NSMutableArray new];
	NSString		*line, *key, *val;
	int inMessage = 0;
	
	for (line in lines) {
		if(!inMessage) {
			if([line length] == 0) {
				inMessage = 1;
			} else {
				NSArray *values = [line componentsSeparatedByString:@" "];
				key = [values objectAtIndex:0];			
				val = [values objectAtIndex:1];			
				if([key isEqualToString: @"tree"]) {
					self.treeSha = val;
				} else if ([key isEqualToString: @"parent"]) {
					[parents addObject:val];
				} else if ([key isEqualToString: @"author"]) {
					NSDictionary *aInfo = [self parseAuthorString:line withType:@"author "];
					[self setAuthor:aInfo];
				} else if ([key isEqualToString: @"committer"]) {
					NSDictionary *cInfo = [self parseAuthorString:line withType:@"committer "];
					[self setCommitter:cInfo];
				}
			}
		} else {
			[buildMessage addObject:line];
		}
    }
	
	[self setMessage:[buildMessage componentsJoinedByString:@"\n"]];
	[buildMessage release];
	
	[self setParentShas:parents];
	[parents release];
	[pool release];
}

- (NSDictionary *) parseAuthorString:(NSString *)authorString withType:(NSString *)typeString
{
	NSMutableDictionary *authorDict;
	
	NSArray *name_email_date;
	name_email_date = [authorString componentsSeparatedByCharactersInSet:
					   [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	
	NSString *nameVal  = [name_email_date objectAtIndex: 0];
	NSString *emailVal = [name_email_date objectAtIndex: 1];
	NSString *dateVal  = [name_email_date objectAtIndex: 2];
	NSDate   *dateDateVal;
	dateDateVal = [NSDate dateWithTimeIntervalSince1970:[dateVal doubleValue]];
	
	NSString *strippedName = [nameVal stringByReplacingOccurrencesOfString:typeString withString:@""];
	authorDict = [NSDictionary dictionaryWithObjectsAndKeys:strippedName, @"name",
															emailVal, @"email",
															dateDateVal, @"date", nil];
	return authorDict;
}

@end
