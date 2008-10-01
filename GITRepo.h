//
//  GITRepo.h
//  ObjectiveGit
//
//  Created by chapbr on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjGitObject.h"
#import "ObjGitCommit.h"

int gitUnpackHex (const unsigned char *rawsha, char *sha1);
int gitPackHex (const char *sha1, unsigned char *rawsha);

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

- (id) initWithPath:(NSString *) gitDir;
- (id) initWithPath:(NSString *) gitDir error:(NSError **) error;
- (id) initWithPath:(NSString *) gitDir bare:(BOOL) bareRepo error:(NSError **) error;

- (BOOL) createGitSubDir:(NSString *) subPath error:(NSError **) error;
- (BOOL) createGitRepoAtPath:(NSString *) gitDir error:(NSError **) error;

- (NSString *) refsPath;
- (NSArray *) refs;
- (NSUInteger) countOfRefs;
- (id) objectInRefsAtIndex:(NSUInteger) i;

- (BOOL) updateRef:(NSString *)refName toSha:(NSString *)toSha error:(NSError **)error;

- (ObjGitCommit *) commitFromSha:(NSString *)sha1;
- (ObjGitObject *) objectFromSha:(NSString *)sha1;
- (NSMutableArray *) commitsFromSha:(NSString *)shaValue limit:(NSUInteger)commitSize;
- (BOOL) hasObject: (NSString *)sha1;
- (NSString *) looseObjectPathBySha: (NSString *)shaValue;
- (NSString *) writeObject:(NSData *)objectData withType:(NSString *)type size:(NSUInteger)size;

@end
