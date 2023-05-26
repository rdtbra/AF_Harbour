/*
 * $Id: _hbhbpdf.c 11881 2009-07-22 17:33:12Z vszakats $
 */

#include "hbapi.h"

#if defined( HB_OS_WIN_CE )

/* NOTE: Ugly hack to make this lib work on WinCE/CEGCC platforms. [vszakats] */

#include <errno.h>

#ifdef __cplusplus
extern "C" {
#endif

_CRTIMP int* __cdecl _errno()
{
   return 0;
}

#ifdef __cplusplus
}
#endif

#endif
