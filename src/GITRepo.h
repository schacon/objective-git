//
//  GITRepo.h
//  ObjectiveGit


#import <Foundation/Foundation.h>
#import "GITObject.h"
#import "GITCommit.h"

@interface GITRepo : NSObject {
	NSString *path;
	NSString *workingDir;
	BOOL bare;
}

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *workingDir;
@property (nonatomic, assign) BOOL bare;

+ (NSString *) unpackSha1Hex:(const unsigned char *)rawsha;
+ (int) gitPackHex:(const char *)sha1 fillRawSha:(unsigned char *)rawsha;
+ (int) gitUnpackHex:(const unsigned char *)rawsha fillSha:(char *)sha1;
+ (int) isAlpha:(unsigned char)n;

+ (id) repoWithPath:(NSString *) gitDir error:(NSError **) error;

- (id) initWithPath:(NSString *) gitDir;
- (id) initWithPath:(NSString *) gitDir error:(NSError **) error;
- (id) initWithPath:(NSString *) gitDir bare:(BOOL) bareRepo error:(NSError **) error;

- (BOOL) createGitSubDir:(NSString *) subPath error:(NSError **) error;
- (BOOL) createGitRepoAtPath:(NSString *) gitDir error:(NSError **) error;

- (NSString *) refsPath;
- (NSArray *) refs;
- (NSUInteger) countOfRefs;
- (NSDictionary *) dictionaryWithRefName:(NSString *) aName sha:(NSString *) shaString;
- (id) objectInRefsAtIndex:(NSUInteger) i;

- (BOOL) updateRef:(NSString *)refName toSha:(NSString *)toSha;
- (BOOL) updateRef:(NSString *)refName toSha:(NSString *)toSha error:(NSError **)error;

- (GITCommit *) commitFromSha:(NSString *)sha1;
- (GITObject *) objectFromSha:(NSString *)sha1;
- (NSMutableArray *) commitsFromSha:(NSString *)shaValue;
- (NSMutableArray *) commitsFromSha:(NSString *)shaValue limit:(NSUInteger)commitSize;
- (BOOL) hasObject: (NSString *)sha1;
- (NSString *) pathForLooseObjectWithSha: (NSString *)shaValue;
- (BOOL) writeObject:(NSData *)objectData withType:(NSString *)type size:(NSUInteger)size;

@end
