/*
 * $Id: prtscr.c 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: prtscr.c
 * Author....: Ted Means
 * CIS ID....: 73067,3332
 *
 * This is an original work by Ted Means and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.3   01 Jan 1995 03:01:00   TED
 * Added dual-mode compatibility.
 *
 *    Rev 1.2   15 Aug 1991 23:08:24   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:53:54   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:02:58   GLENN
 * Nanforum Toolkit
 *
 *
 */

#include "hbapi.h"

#define pbyte *( ( char * ) 0x00400100 )

HB_FUNC( FT_PRTSCR )
{
#if defined( HB_OS_DOS )
   if ( HB_ISLOG( 1 ) )
   {
      if ( hb_parl( 1 ) )
          pbyte = 0;
      else
          pbyte = 1;
   }

   if ( pbyte == 1)
      hb_retl( HB_FALSE );
   else
      hb_retl( HB_TRUE );
#else
   hb_retl( HB_FALSE );
#endif
}
