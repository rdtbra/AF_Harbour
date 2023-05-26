/*
 * $Id: test.prg 14179 2010-03-16 23:34:33Z vszakats $
 */

#include "simpleio.ch"

PROCEDURE Main()
   LOCAL cI, cJ, nErr
   cI := "Hello"
   cJ := HB_BZ2_COMPRESS( cI,, @nErr )
   ? nErr, LEN( cJ ), HB_STRTOHEX( cJ )
   RETURN
