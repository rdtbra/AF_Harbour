/*
 * $Id: ftidle.c 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: idle.c
 * Author....: Ted Means (with much gratitude to Robert DiFalco)
 * CIS ID....: 73067,3332
 *
 * This function is an original work by Ted Means and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.0   01 Jan 1995 03:01:00   TED
 * Initial release
 *
 */

#include "hbdefs.h"
#include "hbapi.h"

HB_FUNC(FT_Idle)
{
   hb_idleState();
}
