/*
 * $Id: nooccur.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: nooccur.prg
 * Author....: David Husnian
 * CIS ID....: ?
 *
 * This is an original work by David Husnian and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:04:08   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:52:32   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:01:52   GLENN
 * Nanforum Toolkit
 *
 */

#define IS_NOT_LOGICAL(x)            (VALTYPE(x) != "L")
#define MAKE_UPPER(x)                (x := UPPER(x))

FUNCTION FT_NOOCCUR(cCheckFor, cCheckIn, lIgnoreCase)

                                        // Is Case Important??
   IF (IS_NOT_LOGICAL(lIgnoreCase) .OR. lIgnoreCase)

      MAKE_UPPER(cCheckFor)             //  No, Force Everything to Uppercase
      MAKE_UPPER(cCheckIn)

   ENDIF                                // IS_NOT_LOGICAL(lIgnoreCase) or ;
                                        // lIgnoreCase

   RETURN iif(LEN(cCheckFor) == 0 .OR. LEN(cCheckIn) == 0, ;
             0, ;
             INT((LEN(cCheckIn) - LEN(STRTRAN(cCheckIn, cCheckFor))) / ;
                  LEN(cCheckFor)))
