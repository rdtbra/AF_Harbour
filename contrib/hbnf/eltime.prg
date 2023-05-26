/*
 * $Id: eltime.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: eltime.prg
 * Author....: Alexander B. Spencer
 * CIS ID....: 76276,1012
 *
 * This is an original work by Alexander B. Spencer and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:06:14   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 20:58:56   GLENN
 * Two locals, nSECS1 and nSECS2, were not declared; this was fixed.
 *
 *    Rev 1.0   07 Jun 1991 23:39:46   GLENN
 * Initial revision.
 *
 */

function FT_ELTIME(cTIME1,cTIME2)
  local  nDELSECS, nHRS, nMINS, nSECS, nSECS1, nSECS2

  nSECS1   := (val(substr(cTIME1,1,2)) * 3600) +;
              (val(substr(cTIME1,4,2)) * 60) + (val(substr(cTIME1,7)))
  nSECS2   := (val(substr(cTIME2,1,2)) * 3600) +;
              (val(substr(cTIME2,4,2)) * 60) + (val(substr(cTIME2,7)))
  nDELSECS := abs(nSECS2 - nSECS1)
  nHRS     := int(nDELSECS / 3600)
  nMINS    := int((nDELSECS - nHRS * 3600) / 60)
  nSECS    := nDELSECS - (nHRS * 3600) - (nMINS * 60)

  return right("00" + ltrim(str(nHRS)),2) + ;
     ":" + ;
     right("00" + ltrim(str(nMINS)),2) + ;
     ":" + ;
     right("00" + ltrim(str(nSECS)),2)
