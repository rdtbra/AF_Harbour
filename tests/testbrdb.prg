/*
 * $Id: testbrdb.prg 3516 2000-11-08 17:28:24Z rglab $
 */

// Testing Browse()

function Main()
   LOCAL cColor

   cColor := SETCOLOR("W+/B")
   CLS

   USE test
   Browse()

   SETCOLOR(cColor)
   CLS

return nil
