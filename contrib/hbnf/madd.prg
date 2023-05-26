/*
 * $Id: madd.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: madd.prg
 * Author....: Jo W. French dba Practical Computing
 * CIS ID....: 74731,1751
 *
 * The functions contained herein are the original work of Jo W. French
 * and are placed in the public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.3   28 Sep 1992 00:39:04   GLENN
 * Jo French cleaned up.
 *
 *    Rev 1.2   15 Aug 1991 23:03:58   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:52:14   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:01:38   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_MADD( dGivenDate, nAddMonths, lMakeEOM)
  LOCAL nAdjDay, dTemp, i

  IF VALTYPE(dGivenDate) != 'D' ; dGivenDate := DATE() ; ENDIF
  IF VALTYPE(nAddMonths) != 'N' ; nAddMonths := 0 ; ENDIF
  IF VALTYPE(lMakeEOM)   != 'L' ; lMakeEom := .F. ; ENDIF

  nAdjDay := DAY( dGivenDate ) - 1

  /* If givendate is end of month and lMakeEom, then force EOM.*/

  lMakeEom := ( lMakeEom .AND. dGivenDate ==  dGivenDate - nAdjDay + 31 - ;
                DAY( dGivenDate - nAdjDay + 31 ) )

  dTemp := dGivenDate - nAdjDay     // first of month

  /* Work with 1st of months.*/
  FOR i := 1 TO ABS(nAddMonths)
      dTemp += iif( nAddMonths > 0, 31, -1 )
      dTemp += 1 - DAY( dTemp )
  NEXT

  IF lMakeEom
     dTemp += 31 - DAY( dTemp + 31 )
  ELSE
     dTemp := MIN( (dTemp + nAdjday), (dTemp += 31 - DAY( dTemp + 31 )))
  ENDIF

RETURN dTemp
