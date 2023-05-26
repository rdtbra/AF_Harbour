/*
 * $Id: tipmime.prg 16425 2011-03-04 12:09:57Z vszakats $
 */

/******************************************
 * TIP test
 * MIME type test
 *
 * This test tries to detect the mime type of a give file.
 *
 * Usage:
 * mimetest filename
 ******************************************/


PROCEDURE MAIN( cFileName )

   IF Empty( cFileName )
      ?
      ? "Usage: mimetest <file to test>"
      ?
      QUIT
   ENDIF
   
   IF ( ! File( cFileName ) )
      ?
      ? "File", cFileName, "is not valid"
      ?
      QUIT
   ENDIF
   
   ? cFileName + ":", Tip_FileMimeType( cFileName )
   ?
   
   RETURN
