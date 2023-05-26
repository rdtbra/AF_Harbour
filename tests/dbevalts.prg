/*
 * $Id: dbevalts.prg 3516 2000-11-08 17:28:24Z rglab $
 */

FUNCTION Main()
   LOCAL nCount

   USE test

   dbGoto( 4 )
   ? RecNo()
   COUNT TO nCount
   ? RecNo(), nCount
   COUNT TO nCount NEXT 10
   ? RecNo(), nCount

   RETURN NIL

