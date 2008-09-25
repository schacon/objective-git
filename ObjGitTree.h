//
//  ObjGitTree.h
//  ObjGit
//

#import <Foundation/Foundation.h>
#import "ObjGitObject.h"

@interface ObjGitTree : NSObject {
	NSArray		  *entryShas;
	ObjGitObject  *gitObject;
}

@property(assign, readwrite) NSArray   *entryShas;
@property(assign, readwrite) ObjGitObject *gitObject;

- (id) initFromGitObject:(ObjGitObject *)object;
- (void) parseContent;
- (void) logObject;

@end
