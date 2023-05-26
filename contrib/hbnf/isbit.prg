/*
 * $Id: isbit.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: isbit.prg
 * Author....: Forest Belt, Computer Diagnostic Services, Inc.
 * CIS ID....: ?
 *
 * This is an original work by Forest Belt and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:03:46   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:52:02   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:01:32   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_ISBIT(cInbyte,nBitPos)

  LOCAL lBitStat

  IF valtype(cInbyte) != "C" .or. valtype(nBitPos) != "N"  // parameter check
     lBitStat := NIL
  ELSE
     if (nBitPos > 7) .or. (nBitPos < 0) .or. (nBitPos != int(nBitPos))
        lBitStat := NIL
     else
        lBitStat := int(((asc(cInByte) * (2 ^ (7 - nBitPos))) % 256) / 128) == 1
     endif
  ENDIF

RETURN lBitStat
