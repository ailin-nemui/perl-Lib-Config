#ifndef __MODULE_H
#define __MODULE_H

#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <ctype.h>

/* max. size for %d */
#define MAX_INT_STRLEN ((sizeof(int) * CHAR_BIT + 2) / 3 + 1)

#define g_free_not_null(a) g_free(a)

#define g_free_and_null(a) \
	G_STMT_START { \
	  if (a) { g_free(a); (a) = NULL; } \
	} G_STMT_END

/* ctype.h isn't safe with chars, use our own instead */
#define i_toupper(x) toupper((int) (unsigned char) (x))
#define i_tolower(x) tolower((int) (unsigned char) (x))
#define i_isalnum(x) isalnum((int) (unsigned char) (x))
#define i_isalpha(x) isalpha((int) (unsigned char) (x))
#define i_isascii(x) isascii((int) (unsigned char) (x))
#define i_isblank(x) isblank((int) (unsigned char) (x))
#define i_iscntrl(x) iscntrl((int) (unsigned char) (x))
#define i_isdigit(x) isdigit((int) (unsigned char) (x))
#define i_isgraph(x) isgraph((int) (unsigned char) (x))
#define i_islower(x) islower((int) (unsigned char) (x))
#define i_isprint(x) isprint((int) (unsigned char) (x))
#define i_ispunct(x) ispunct((int) (unsigned char) (x))
#define i_isspace(x) isspace((int) (unsigned char) (x))
#define i_isupper(x) isupper((int) (unsigned char) (x))
#define i_isxdigit(x) isxdigit((int) (unsigned char) (x))

#include "iconfig.h"

/* private */
int config_error(CONFIG_REC *rec, const char *msg);

#endif
