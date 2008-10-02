//
//  GITCommit.h
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"

@interface GITCommit : NSObject {
	NSArray	   *parentShas;
	NSString   *treeSha;
	NSMutableDictionary *author;
	NSMutableDictionary *committer;
	NSString   *message;
	GITObject  *gitObject;
}

@property(copy, readwrite) NSArray   *parentShas;
@property(copy, readwrite) NSString    *treeSha;
@property(copy, readwrite) NSString  *message;	
@property(retain, readwrite) GITObject *gitObject;

@property(copy, readonly) NSMutableDictionary *author;
- (void) setAuthor:(NSDictionary *) newAuthor;

@property(copy, readonly) NSMutableDictionary *committer;
- (void) setCommitter:(NSDictionary *) newAuthor;

- (id) initFromGitObject:(GITObject *)gObject;
- (id) initFromRaw:(NSData *)rawData withSha:(NSString *)shaValue;
- (void) parseContent;
- (void) logObject;
- (NSArray *) authorArray; 
- (NSDictionary *) parseAuthorString:(NSString *)authorString withType:(NSString *)typeString;

@end
