/*
 * $Id: dfile.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: dfile.prg
 * Author....: Mike Taylor
 * CIS ID....: ?
 *
 * This is an original work by Mike Taylor and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.3   17 Aug 1991 15:24:14   GLENN
 * Don Caton corrected some spelling errors in the doc
 *
 *    Rev 1.2   15 Aug 1991 23:03:24   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:32   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:01:08   GLENN
 * Nanforum Toolkit
 *
 */

THREAD static nHandle := 0

#ifdef FT_TEST

    FUNCTION MAIN()

    @ 0,0 CLEAR

    cInFile   := "ft_dfile.prg"
    CKEY      := ""
    NNCOLOR   := 7
    NHCOLOR   := 15
    NCOLSKIP  := 5
    NRMARGIN  := 132
    CEXITKEYS := "AABBC       "
    LBROWSE   := .F.
    NSTART    := 1
    NBUFFSIZE := 4096

    @ 0,0  SAY "ENTER FILENAME: "   GET CINFILE
    @ 1,0  SAY "    FOREGROUND: "   GET NNCOLOR   PICTURE "999"
    @ 2,0  SAY "     HIGHLIGHT: "   GET NHCOLOR   PICTURE "999"
    @ 3,0  SAY "     EXIT KEYS: "   GET CEXITKEYS
    @ 4,0  SAY "   BUFFER SIZE: "   GET NBUFFSIZE PICTURE "9999"
    @ 1,40 SAY "COLUMN INCREMENT: " GET NCOLSKIP  PICTURE "999"
    @ 2,40 SAY "   MAX LINE SIZE: " GET NRMARGIN  PICTURE "999"
    @ 3,40 SAY "     BROWSE MODE? " GET LBROWSE   PICTURE "Y"

    READ

    /*
     * REMEMBER A WINDOW WILL BE ONE SIZE LESS AND GREATER THAN THE PASSED COORD.'S
     *
     * THE 9TH PARAMETER CONTAINS THE KEYS THAT THE ROUTINE WILL TERMINATE ON
     * AND THE CHR(143) represents the F3 key.
     *
     */

    @ 4,9 TO 11,71

    FT_DFSETUP(cInFile, 5, 10, 10, 70, nStart,;
               nNColor, nHColor, cExitKeys + CHR(143),;
               lBrowse, nColSkip, nRMargin, nBuffSize)

    cKey := FT_DISPFILE()

    FT_DFCLOSE()

    @ 20,0 SAY "Key pressed was: " + '[' + cKey + ']'

    return (NIL)

#endif

function FT_DFSETUP(cInFile, nTop, nLeft, nBottom, nRight,;
                    nStart, nCNormal, nCHighlight, cExitKeys,;
                    lBrowse, nColSkip, nRMargin, nBuffSize )

  local rval

  if File(cInFile)
     nTop    := iif(ValType(nTop)    == "N", nTop,           0)
     nLeft   := iif(ValType(nLeft)   == "N", nLeft,          0)
     nBottom := iif(ValType(nBottom) == "N", nBottom, MaxRow())
     nRight  := iif(ValType(nRight)  == "N", nRight,  MaxCol())

     nCNormal    := iif(ValType(nCNormal)    == "N", nCNormal,     7)
     nCHighlight := iif(ValType(nCHighlight) == "N", nCHighlight, 15)

     nStart    := iif(ValType(nStart)    == "N", nStart,      1)
     nColSkip  := iif(ValType(nColSkip)  == "N", nColSkip,    1)
     lBrowse   := iif(ValType(lBrowse)   == "L", lBrowse,   .F.)

     nRMargin  := iif(ValType(nRMargin)  == "N", nRMargin,   255)
     nBuffSize := iif(ValType(nBuffSize) == "N", nBuffSize, 4096)

     cExitKeys := iif(ValType(cExitKeys) == "C", cExitKeys,  "")

     cExitKeys := iif(Len(cExitKeys) > 25, SubStr(cExitKeys, 1, 25), cExitKeys)

     nHandle := FOpen(cInFile)

     rval := FError()

     if ( rval == 0 )
           rval := _FT_DFINIT(nHandle, nTop, nLeft, nBottom, nRight,;
                              nStart, nCNormal, nCHighlight, cExitKeys,;
                              lBrowse, nColSkip, nRMargin, nBuffSize)
     endif
  else
     rval := 2       // simulate a file-not-found DOS file error
  endif

return (rval)

function FT_DFCLOSE()

  if ( nHandle > 0 )
     _FT_DFCLOS()

     FClose(nHandle)

     nHandle := 0
  endif

  return (NIL)
