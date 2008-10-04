//
//  GITObject.h
//  ObjectiveGit


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

+ (id) objectWithRaw:(NSData *)rawData sha:(NSString *)shaValue;

- (id) initWithRaw:(NSData *)rawData sha:(NSString *)shaValue;
- (void) parseRaw;

- (NSString *) contents;

- (void) setRaw:(NSData *) rawData inflate:(BOOL) inflate;
- (NSData *) inflateRaw:(NSData *)rawData;

- (NSComparisonResult) isEqualToObject:(GITObject *) otherObject;

@end
