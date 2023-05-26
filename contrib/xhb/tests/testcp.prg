/*
 * $Id: testcp.prg 9444 2008-09-18 19:32:00Z vszakats $
 */

PROCEDURE Main()

   XHB_COPYFILE( "testcp.prg", "testcp.bak", {| x | QOut( x ) } )

   RETURN
