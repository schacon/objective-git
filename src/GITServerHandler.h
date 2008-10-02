//
//  GITServerHandler.h
//  ObjectiveGit
//
//  Created by chapbr on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#import "GITRepo.h"
#import "GITObject.h"

@interface GITServerHandler : NSObject {
	NSURL *remoteURL;
	NSString *workingDir;
	
	// use SmallSockets library?
	//BufferedSocket *gitSocket;
	
	NSInputStream *inStream;
	NSOutputStream *outStream;
	GITRepo *gitRepo;
	
	NSMutableArray *refsRead;
	NSMutableArray *needRefs;
	NSMutableDictionary *refDict;
	
	int	capabilitiesSent; // Why not use a BOOL here?
}

@property(copy, readwrite) NSURL *remoteURL;
@property(copy, readwrite) NSString *workingDir;

@property(retain, readwrite) NSInputStream *inStream;	
@property(retain, readwrite) NSOutputStream *outStream;	
@property(retain, readwrite) GITRepo *gitRepo;

@property(copy, readwrite) NSMutableArray *refsRead;
@property(copy, readwrite) NSMutableArray *needRefs;
@property(copy, readwrite) NSMutableDictionary *refDict;

@property(assign, readwrite) int capabilitiesSent;


//- (void) initWithGit:(GITRepo *)git gitPath:(NSString *)gitRepoPath input:(NSInputStream *)streamIn output:(NSOutputStream *)streamOut;
- (void) handleRequest;

- (void) uploadPack:(NSString *)repositoryName;
- (void) receiveNeeds;
- (void) uploadPackFile;
- (void) sendNack;
- (void) sendPackData;

- (void) receivePack:(NSString *)repositoryName;
- (void) gatherObjectShasFromCommit:(NSString *)shaValue;
- (void) gatherObjectShasFromTree:(NSString *)shaValue;
- (void) respondPack:(uint8_t *)buffer length:(int)size checkSum:(CC_SHA1_CTX *)checksum;

- (void) sendRefs;
- (void) sendRef:(NSString *)refName sha:(NSString *)shaString;
- (void) readRefs;
- (void) readPack;
- (void) writeRefs;
- (NSData *) readData:(int)size;
- (NSString *) typeString:(int)type;
- (int) typeInt:(NSString *)type;
- (void) unpackDeltified:(int)type size:(int)size;

- (NSData *) patchDelta:(NSData *)deltaData withObject:(GITObject *)gitObject;
- (NSArray *) patchDeltaHeaderSize:(NSData *)deltaData position:(unsigned long)position;

- (NSString *)readServerSha;
- (int) readPackHeader;
- (void) unpackObject;

- (void) longVal:(uint32_t)raw toByteBuffer:(uint8_t *)buffer;
- (void) packetFlush;
- (void) writeServer:(NSString *)dataWrite;
- (void) writeServerLength:(unsigned int)length;
- (void) sendPacket:(NSString *)dataSend;
- (NSString *) packetReadLine;

@end
