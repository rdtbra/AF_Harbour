//
// $Id: testfor.prg 11712 2009-07-11 05:46:08Z vszakats $
//

PRCOEDURE MAIN

   LOCAL i

   FOR i := 1 TO 10

      QOut( i )

      IF i == 4 .AND. .T.
         __Accept( "" )
         QOut( i )
         i := 9
         QOut( i )
         __Accept( "" )
      ENDIF

   NEXT

   RETURN
