//
//  GITTree.m
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GITTree.h"


@implementation GITTree

@synthesize	treeEntries;
@synthesize gitObject;

- (id) initFromGitObject:(GITObject *)object {
	if (! [super init])
		return nil;

	[self setGitObject:object];
	[self parseContent];
	return self;
}

- (void) logObject
{
	NSLog(@"entries : %@", [self treeEntries]);
}

// 100644 testfile\0[20 char sha]
- (void) parseContent
{
	NSData *contentsData = [[self gitObject] contentsData];
	const char *contents = [contentsData bytes];
	
	NSUInteger contentLen = [[self gitObject] rawContentLen];
	
	char mode[9];
	int modePtr = 0;
	char name[255];
	int namePtr = 0;
	char sha[41];
	unsigned char rawsha[20];
	
	NSString *shaStr, *modeStr, *nameStr;
	NSArray  *entry;
	NSMutableArray *entries = [[NSMutableArray alloc] init];
	
	int i, j, state;
	state = 1;
	
	for(i = 0; i < contentLen - 1; i++) {
		if(contents[i] == 0) {
			state = 1;
			for(j = 0; j < 20; j++)
				rawsha[j] = contents[i + j + 1];
			i += 20;
			[ObjGit gitUnpackHex:rawsha fillSha:sha];
			
			mode[modePtr] = 0;
			name[namePtr] = 0;
			
			shaStr  = [[NSString alloc] initWithBytes:sha  length:40      encoding:NSASCIIStringEncoding];	
			modeStr = [[NSString alloc] initWithBytes:mode length:modePtr encoding:NSASCIIStringEncoding];	
			nameStr = [[NSString alloc] initWithBytes:name length:namePtr encoding:NSUTF8StringEncoding];	
			
			entry = [NSArray arrayWithObjects:modeStr, nameStr, shaStr, nil];
			[shaStr release];
			[modeStr release];
			[nameStr release];
			
			[entries addObject:entry];
			
			modePtr = 0;
			namePtr = 0;
		} else {					// contents
			if(contents[i] == 32) {
				state = 2;
			} else if(state == 1) { // mode
				mode[modePtr] = contents[i];
				modePtr++;
			} else {				// name
				name[namePtr] = contents[i];
				namePtr++;
			}
		}
	}
	[self setTreeEntries:entries];
	[entries release];
}

@end
