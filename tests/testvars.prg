//
// $Id: testvars.prg 2265 2000-03-06 21:18:43Z vszel $
//

MEMVAR I

Function Main(Param1)

   local i, j, k

    i := 1
    j := 2

    Sub( @j )

    QOut( j )

return NIL

Function Sub( j )

    m->i := 1
    j := 3

return NIL

Function arrvar()

   //local i := {1}

   i[1] := 2

return NIL
