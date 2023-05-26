/*
 * $Id: byteneg.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: byteneg.prg
 * Author....: Forest Belt, Computer Diagnostic Services, Inc.
 * CIS ID....: ?
 *
 * This is an original work by Forest Belt and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:03:04   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:14   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:00:52   GLENN
 * Nanforum Toolkit
 *
 */

FUNCTION FT_BYTENEG(cByte)
RETURN   iif(valtype(cByte) != "C", NIL, chr((256 - asc(cByte)) % 256))
