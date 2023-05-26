/*
 * $Id: firstday.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: firstday.prg
 * Author....: Jeff Bryant
 * CIS ID....: ?
 *
 * This function is an original work by Jeff Bryant and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:03:38   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:54   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:01:24   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_FDAY(dDateToChk)

   IF Valtype(dDatetoChk) # "D"
      dDatetoChk := Date()
   ENDIF

   RETURN dDateToChk - (DAY(dDateToChk)-1)
