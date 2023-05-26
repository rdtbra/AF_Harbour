/*
 * $Id: cntryset.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: cntryset.prg
 * Author....: David Husnian
 * CIS ID....: ?
 *
 * This is an original work by David Husnian and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:03:12   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:20   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:00:58   GLENN
 * Nanforum Toolkit
 *
 */

#define IS_LOGICAL(x)                (VALTYPE(x) == "L")

FUNCTION FT_SETCENTURY(lNewSetState)
                                        // Note that if CENTURY is ON then
                                        // DTOC() Will Return a String of Length
                                        // 10, Otherwise it Will be of Length 8
   LOCAL lOldSetState := (LEN(DTOC(DATE())) == 10)

   IF (IS_LOGICAL(lNewSetState))        // Did They Want it Set??
      SET CENTURY (lNewSetState)        // Yes, Set it
   ENDIF                                // IS_LOGICAL(lNewSetState)
   RETURN lOldSetState                  // FT_SetCentury
