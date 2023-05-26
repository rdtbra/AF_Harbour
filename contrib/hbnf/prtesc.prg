/*
 * $Id: prtesc.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: prtesc.prg
 * Author....: Steven Tyrakowski
 * CIS ID....: ?
 *
 * This is an original work by Steven Tyrakowski and is placed
 * in the public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:04:26   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:52:42   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:02:02   GLENN
 * Nanforum Toolkit
 *
 */

#ifdef FT_TEST
  FUNCTION MAIN( cParm1 )
     *-------------------------------------------------------
     * Sample routine to test function from command line
     *-------------------------------------------------------

    IF PCount() > 0
      ? FT_ESCCODE( cParm1 )
    ELSE
      ? "Usage: PRT_ESC  'escape code sequence' "
      ? "            outputs converted code to  standard output"
      ?
    ENDIF
  RETURN (nil)
#endif

FUNCTION FT_ESCCODE( cInput )

LOCAL cOutput  := ""             ,;
      cCurrent                   ,;
      nPointer := 1              ,;
      nLen     := Len( cInput )

  DO WHILE nPointer <= nLen

    cCurrent := Substr( cInput, nPointer, 1 )

    DO CASE

       CASE cCurrent == "\" .AND. ;
            IsDigit(Substr(cInput, nPointer+1, 1) ) .AND. ;
            IsDigit(Substr(cInput, nPointer+2, 1) ) .AND. ;
            IsDigit(Substr(cInput, nPointer+3, 1) )
         cOutput  += Chr(Val(Substr(cInput, nPointer+1,3)))
         nPointer += 4

       CASE cCurrent == "\" .AND. ;
            Substr(cInput, nPointer+1, 1) == "\"
         cOutput += "\"
         nPointer += 2

       OTHERWISE
         cOutput += cCurrent
         nPointer++

    ENDCASE
  ENDDO

RETURN cOutput
