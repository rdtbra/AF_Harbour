/*
 * $Id: curdirt.prg 1519 1999-10-04 18:46:41Z vszel $
 */

FUNCTION Main()

   OutStd( CurDir()     + Chr(13) + Chr(10) )
   OutStd( CurDir("C")  + Chr(13) + Chr(10) )
   OutStd( CurDir("C:") + Chr(13) + Chr(10) )
   OutStd( CurDir("D:") + Chr(13) + Chr(10) )
   OutStd( CurDir("A")  + Chr(13) + Chr(10) )

   RETURN NIL
