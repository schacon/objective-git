/*
 *  git-pack.h
 *  ObjectiveGit
 */
#define IS_APLHA(n)	(n <= 102 && n >= 97) ? 1 : 0

int gitUnpackHex (const unsigned char *rawsha, char *sha1);
int gitPackHex (const char *sha1, unsigned char *rawsha);