//
// $Id: procline.prg 1519 1999-10-04 18:46:41Z vszel $
//


FUNCTION Main()

? "hello 1", ProcLine(), "Expected: ", 8

? "hello 2", ProcLine(), "Expected: ", 10

? "hello 3", ProcLine(), "Expected: ", 12

RETURN NIL
