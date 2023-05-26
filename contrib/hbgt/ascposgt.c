/*
 * $Id: ascposgt.c 14827 2010-06-19 14:26:56Z vszakats $
 */

/*
 * GT CLIPPER STANDARD HEADER
 *
 * File......: ascpos.c
 * Author....: Andy M Leighton
 * BBS.......: The Dark Knight Returns
 * Net/Node..: 050/069
 * User Name.: Andy Leighton
 * Date......: 23/05/93
 * Revision..: 1.00
 *
 * This is an original work by Andy Leighton and is placed in the
 * public domain.
 */

#include "hbapi.h"

HB_FUNC( GT_ASCPOS )
{
  const char *s;
  HB_SIZE p;

  if (HB_ISCHAR(1) && HB_ISNUM(2)) {
    s = hb_parc(1);
    p = hb_parns(2);
    p--;                            /* decrement p to adjust for c strings */
                                    /* starting at position 0 */

    if (p > hb_parclen(1))            /* oh oh p > length of passed string */
      hb_retni(-2);                   /* error -2 */
    else
      hb_retni((int) s[p]);           /* return ascii code of appropriate */
                                    /* character in string */
  } else {
    hb_retni(-1);                     /* parameter mismatch - error -1 */
  }
}
