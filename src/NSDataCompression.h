//
//  NSDataCompression.h
//  ObjGit
//
//  thankfully borrowed from the Etoile framework
//  NOTE: similar methods available on cocoadev.com:
//        http://www.cocoadev.com/index.pl?NSDataCategory


#include <Foundation/Foundation.h>

@interface NSData (Compression)

- (NSData *) compressedData;
- (NSData *) decompressedData;

@end
