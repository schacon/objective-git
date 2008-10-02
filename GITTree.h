//
//  GITTree.h
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GITObject.h"

@interface GITTree : NSObject {
	NSArray	*treeEntries;
	GITObject *gitObject;
}

@property(copy, readwrite) NSArray   *treeEntries;
@property(retain, readwrite) GITObject *gitObject;

+ (id) treeWithGitObject:(GITObject *)object;

- (id) initWithGitObject:(GITObject *)object;
- (void) parseContent;
- (void) logObject;

@end
