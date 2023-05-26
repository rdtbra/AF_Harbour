/*
 * $Id: restsets.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: restsets.prg
 * Author....: David Husnian
 * CIS ID....: ?
 *
 * This is an original work by David Husnian and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:02:34   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   27 May 1991 13:04:20   GLENN
 * Minor documentation change.
 *
 *    Rev 1.0   01 Apr 1991 01:02:06   GLENN
 * Nanforum Toolkit
 *
 */

#include "set.ch"

#Define FT_EXTRA_SETS    2
#DEFINE FT_SET_CENTURY   _SET_COUNT + 1
#DEFINE FT_SET_BLINK     _SET_COUNT + 2

FUNCTION  FT_RESTSETS(aOldSets)

   AEVAL(aOldSets, ;
         { | xElement, nElementNo | ;
           SET(nElementNo, xElement) }, ;
         1, _SET_COUNT )

   FT_SETCENTURY(aOldSets[FT_SET_CENTURY])
   SETBLINK(aOldSets[FT_SET_BLINK])

   RETURN (NIL)                         // FT_RestSets
