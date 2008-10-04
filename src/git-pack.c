/*
 *  git-pack.c
 *  ObjectiveGit
 *
 */

#include "git-pack.h"

int gitUnpackHex (const unsigned char *rawsha, char *sha1)
{
	static const char hex[] = "0123456789abcdef";
	int i;
	
	for (i = 0; i < 20; i++) {          
		unsigned char n = rawsha[i];
		sha1[i * 2] = hex[((n >> 4) & 15)];
		n <<= 4;
		sha1[(i * 2) + 1] = hex[((n >> 4) & 15)];
	}
	sha1[40] = '\0';
	
	return 1;   
}


/*
 * fills 20-char sha from 40-char hex version
 */

int gitPackHex (const char *sha1, unsigned char *rawsha)
{
	unsigned char byte = 0;
	int i, j = 0;
	
	for (i = 1; i <= 40; i++) {
		unsigned char n = sha1[i - 1];
		
		if(IS_APLHA(n)) {
			byte |= ((n & 15) + 9) & 15;
		} else {
			byte |= (n & 15);
		}
		if(i & 1) {
			byte <<= 4;
		} else {
			rawsha[j] = (byte & 0xff);
			j++;
			byte = 0;
		}
	}
	return 1;
}
