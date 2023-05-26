/*
 * $Id: test.prg 14470 2010-05-13 08:01:33Z vszakats $
 */

PROCEDURE Main()

   LOCAL s := " " + Chr( 0 ) + "  mab  " + Chr( 0 ) + " "

   StrDump( s )
   QOut( s )

   QOut( '"' + LTrim( s ) + '"' )
   QOut( '"' + RTrim( s ) + '"' )
   QOut( '"' + AllTrim( s ) + '"' )

   RETURN

STATIC PROCEDURE StrDump( s )
   LOCAL tmp
   FOR EACH tmp IN s
      QOut( Asc( tmp ) )
   NEXT
   RETURN
