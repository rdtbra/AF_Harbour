/*
 * $Id: zipa.prg 14088 2010-03-07 14:19:03Z vszakats $
 */

PROCEDURE Main( cZip, ... )
    LOCAL a, b, c

    SET DATE TO ANSI
    SET CENTURY ON

    ? hb_ZipFile( cZip, hb_AParams() )

    a := hb_GetFilesInZip( cZip, .T. )

    FOR EACH b IN a
       ?
       FOR EACH c IN b
          ?? c, ""
       NEXT
    NEXT

    RETURN
