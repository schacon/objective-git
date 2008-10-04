//
//  GITTree.h
//  ObjectiveGit

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
