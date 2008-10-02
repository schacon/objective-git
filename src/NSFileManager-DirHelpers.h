//
//  NSFileManager-DirHelper.h
//  ObjectiveGit
//
//  Created by chapbr on 9/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (DirHelpers)

+ (BOOL) directoryExistsAtPath:(NSString *) aPath;
+ (BOOL) directoryExistsAtURL:(NSURL *) aURL;
+ (BOOL) fileExistsAtPath:(NSString *) aPath;
+ (BOOL) fileExistsAtURL:(NSURL *) aURL;

@end
