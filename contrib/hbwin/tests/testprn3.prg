/*
 * $Id: testprn3.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE Main()

   Dump( WIN_PRINTERLIST( .F., .F. ) )
   Dump( WIN_PRINTERLIST( .F., .T. ) )
   Dump( WIN_PRINTERLIST( .T., .F. ) )
   Dump( WIN_PRINTERLIST( .T., .T. ) )

   ? "WIN_PRINTERGETDEFAULT:", ">" + WIN_PRINTERGETDEFAULT() + "<"
   ? "WIN_PRINTERSTATUS:", WIN_PRINTERSTATUS()

   RETURN

STATIC PROCEDURE Dump( a )
   LOCAL b, c

   ? "=================="
   FOR EACH b IN a
      ?
      IF ValType( b ) == "A"
         FOR EACH c IN b
            ?? c:__enumIndex(), c
            IF c:__enumIndex() == 2
               ?? ">>" + WIN_PRINTERPORTTONAME( c ) + "<<",  "|>>" + WIN_PRINTERPORTTONAME( c, .T. ) + "<<|"
            ENDIF
            ?
         NEXT
         ? "-----"
      ELSE
         ? b, WIN_PRINTEREXISTS( b ), WIN_PRINTERSTATUS( b )
      ENDIF
   NEXT

   RETURN
