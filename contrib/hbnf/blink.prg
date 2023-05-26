/*
 * $Id: blink.prg 15103 2010-07-14 12:57:05Z vszakats $
 */

/*
 * File......: blink.prg
 * Author....: Terry Hackett
 * CIS ID....: 76662,2035
 *
 * This is an original work by Terry Hackett and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.2   15 Aug 1991 23:02:56   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.1   14 Jun 1991 19:51:06   GLENN
 * Minor edit to file header
 *
 *    Rev 1.0   01 Apr 1991 01:00:46   GLENN
 * Nanforum Toolkit
 *
 */

#ifdef FT_TEST
  FUNCTION MAIN()
     FT_BLINK( "WAIT", 5, 10 )
     RETURN NIL
#endif

FUNCTION FT_BLINK( cMsg, nRow, nCol )

  * Declare color restore var.
  LOCAL cSavColor

  * Return if no msg.
  IF (cMsg == NIL) ; RETURN NIL; ENDIF

  * Set default row and col to current.
  nRow := iif( nRow == NIL, ROW(), nRow )
  nCol := iif( nCol == NIL, COL(), nCol )

  cSavColor := SETCOLOR()                // Save colors to restore on exit.

  * IF blink colors not already set, add blink to current foreground color.
  SETCOLOR( iif( ("*" $ LEFT(cSavColor,4)), cSavColor, "*" + cSavColor ) )

  @ nRow, nCol SAY cMsg                  // Say the dreaded blinking msg.
  SETCOLOR( cSavColor )                  // It's a wrap, restore colors & exit.

RETURN NIL
