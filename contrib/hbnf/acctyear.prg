/*
 * $Id: acctyear.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: acctyear.prg
 * Author....: Jo W. French dba Practical Computing
 * CIS ID....: 74731,1751
 *
 * The functions contained herein are the original work of Jo W. French
 * and are placed in the public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.3   28 Sep 1992 00:29:14   GLENN
 * Jo French clean up.
 *
 *    Rev 1.2   15 Aug 1991 23:02:40   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:50:48   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:00:28   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_ACCTYEAR(dGivenDate)

  LOCAL nYTemp, aRetVal

  IF !( VALTYPE(dGivenDate) == "D" )
    dGivenDate := DATE()
  ENDIF

  aRetVal    := FT_YEAR(dGivenDate)
  nYTemp     := VAL(aRetVal[1])
  aRetVal[2] := FT_ACCTADJ(aRetVal[2])
  aRetVal[3] := FT_ACCTADJ(aRetVal[3], .T. )

  IF dGivenDate < aRetVal[2]
    aRetVal    := FT_YEAR(FT_MADD(dGivenDate, -1))
    nYTemp --
    aRetVal[2] := FT_ACCTADJ(aRetVal[2])
    aRetVal[3] := FT_ACCTADJ(aRetVal[3], .T. )
  ELSEIF dGivenDate > aRetVal[3]
    aRetVal    := FT_YEAR(FT_MADD(dGivenDate, 1))
    nYTemp ++
    aRetVal[2] := FT_ACCTADJ(aRetVal[2])
    aRetVal[3] := FT_ACCTADJ(aRetVal[3], .T. )
  ENDIF

  aRetVal[1] := STR(nYTemp,4)

RETURN aRetVal
