/*
 * $Id: ftgete.prg 12732 2009-10-19 21:17:04Z vszakats $
 */

#include "simpleio.ch"

PROCEDURE main()

   LOCAL a
   LOCAL c

   LOCAL tmp

   a := Array( FT_GETE() )
   FT_GETE( @a )
   FOR tmp := 1 TO Len( a )
      ? a[ tmp ]
   NEXT

   ? "-------------------------------------"

   c := ""
   FT_GETE( @c )
   ? c

   RETURN
