/*
 *  git-pack.h
 *  ObjectiveGit
 *
 *  Created by chapbr on 10/1/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
#define IS_APLHA(n)	(n <= 102 && n >= 97) ? 1 : 0

int gitUnpackHex (const unsigned char *rawsha, char *sha1);
int gitPackHex (const char *sha1, unsigned char *rawsha);