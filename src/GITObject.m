//
//  GITObject.m
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GITObject.h"
#import "NSDataCompression.h"

@implementation GITObject

@synthesize sha;
@synthesize size;
@synthesize type;
@synthesize raw;
@synthesize contentsData;

@synthesize rawContentLen;

+ (id) objectWithRaw:(NSData *)rawData sha:(NSString *)shaValue;
{
	return [[[self alloc] initWithRaw:rawData sha:shaValue] autorelease];
}

- (id) initWithRaw:(NSData *)rawData sha:(NSString *)shaValue
{
	if (! [super init])
		return nil;

	[self setSha:shaValue];
	[self setRaw:rawData inflate:YES];
	[self parseRaw];
	return self;
}

- (void) dealloc;
{
	[sha release];
	[type release];
	[raw release];
	[contentsData release];
	[super dealloc];
}

- (void) parseRaw
{
	char *bytes = (char *)[[self raw] bytes]; 
    NSUInteger len = [[self raw] length];

	//NSData *headerData = [NSData dataWithBytes:bytes length:strlen(bytes)];
	NSString *header = [[NSString alloc] initWithBytes:bytes 
												length:strlen(bytes) 
											  encoding:NSASCIIStringEncoding];

	NSArray *headerChunks = [header componentsSeparatedByString:@" "];
	[header release];
	
	[self setType:[headerChunks objectAtIndex:0]];
	[self setSize:[[headerChunks objectAtIndex:1] intValue]];
	
	NSUInteger contentOffset = strlen(bytes) + 1;
	rawContentLen = len - contentOffset;
	NSRange contentRange = NSMakeRange(contentOffset, rawContentLen);
	NSData *contentData = [[self raw] subdataWithRange:contentRange];
	[self setContentsData:contentData];
}

- (NSUInteger) getRawContents:(char *) buf;
{
	return 0;
}

- (NSString *) contents;
{
	return [[[NSString alloc] initWithData:contentsData encoding:NSASCIIStringEncoding] autorelease];
}

- (void) setRaw:(NSData *) rawData inflate:(BOOL) inflate;
{
	if (inflate)
		[self setRaw:[rawData decompressedData]];
	else
		[self setRaw:rawData];
}

- (NSData *) inflateRaw:(NSData *)rawData
{
	return [rawData decompressedData];
}

- (NSComparisonResult) isEqualToObject:(GITObject *) otherObject;
{
	return [[self raw] isEqualToData:[otherObject raw]];
}

@end
