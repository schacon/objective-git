//
//  ObjGitTree.m
//  ObjGit
//

#import "ObjGitObject.h"
#import "ObjGitTree.h"

@implementation ObjGitTree

@synthesize	entryShas;
@synthesize gitObject;

- (id) initFromGitObject:(ObjGitObject *)object {
	self = [super init];	
	gitObject = object;
	[self parseContent];
	return self;
}

- (void) logObject
{
	NSLog(@"entries  : %@", entryShas);
}

- (void) parseContent
{
	// extract tree entries
	NSString *line;
	NSArray	 *lines = [gitObject.contents componentsSeparatedByString:@"\0"];
	
	NSEnumerator	*enumerator;
	enumerator = [lines objectEnumerator];
	while ((line = [enumerator nextObject]) != nil) {
		NSLog(@"line: %@", line);
    }
}

@end
