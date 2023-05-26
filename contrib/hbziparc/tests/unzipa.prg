/*
 * $Id: unzipa.prg 9290 2008-09-01 13:58:19Z vszakats $
 */

PROCEDURE Main( cZip, ... )

    ? hb_UnzipFile( cZip, NIL, .F., NIL, NIL, hb_AParams(), {|x, y| QOut( Str( x / y * 100, 3 ) + "%" ) } )

    RETURN
