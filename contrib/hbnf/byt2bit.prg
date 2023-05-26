/*
 * $Id: byt2bit.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: byt2bit.prg
 * Author....: Forest Belt, Computer Diagnostic Services, Inc.
 * CIS ID....: ?
 *
 * This is an original work by Forest Belt and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:02:58   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:08   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:00:48   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_BYT2BIT(cByte)

  local nCounter, xBitstring

  IF valtype(cByte) != "C"
     xBitString := NIL
  ELSE
     xBitString := ""
     FOR nCounter := 7 TO 0 step -1
        xBitString += iif(FT_ISBIT(cByte, nCounter), "1", "0")
     NEXT
  ENDIF

RETURN xBitString
