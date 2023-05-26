/*
 * $Id: origin.c 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: origin.c
 * Author....: Steve Larsen
 * CIS ID....: 76370,1532
 *
 * This is an original work by K. Stephan Larsen and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.1   09 Nov 1992 22:35:52   GLENN
 * Function was inadvertently named origin() instead of ft_origin() when
 * it went from an .asm to a .c file.  Renamed it back to ft_origin().
 *
 *    Rev 1.0   03 Oct 1992 02:13:54   GLENN
 * Initial revision.
 *
 */

#include "hbapi.h"

HB_FUNC( FT_ORIGIN )
{
   hb_retc( hb_cmdargARGV()[ 0 ] );
}
