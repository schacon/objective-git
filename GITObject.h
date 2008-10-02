//
//  GITObject.h
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GITObject : NSObject {
	NSString *sha;
	NSUInteger size;
	NSString *type;
	NSUInteger rawContentLen;
	NSData *raw;
	NSData *contentsData;
}

@property(copy, readwrite) NSString *sha;	
@property(assign, readwrite) NSUInteger size;	
@property(copy, readwrite) NSString *type;	
@property(assign, readwrite) NSUInteger rawContentLen;
@property(copy, readwrite) NSData   *raw;	
@property(copy, readwrite) NSData   *contentsData;	

- (id) initFromRaw:(NSData *)rawData withSha:(NSString *)shaValue;
- (void) parseRaw;

- (NSString *) contents;

- (void) setRaw:(NSData *) rawData inflate:(BOOL) inflate;
- (NSData *) inflateRaw:(NSData *)rawData;

@end
