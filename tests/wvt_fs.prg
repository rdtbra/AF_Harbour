/*
 * $Id: wvt_fs.prg 16401 2011-02-28 20:09:19Z vszakats $
 */

#include "hbgtinfo.ch"
#include "inkey.ch"

PROCEDURE MAIN()
   LOCAL cGt

   cGt := HB_GtVersion( 0 )
   IF cGt == "WVT"
      HB_GtInfo( HB_GTI_FONTNAME, "Lucida Console" )
   ELSE
      ? "launch me under GTWVT"
      QUIT
   ENDIF

   ? "GTWVT test"

   ?  HB_GtInfo( HB_GTI_ISFULLSCREEN, .T. ), "we should be on full screen"
   WAIT
   ?  HB_GtInfo( HB_GTI_ISFULLSCREEN, .F. ), "we should be windowed"
   ?  HB_GtInfo( HB_GTI_ALTENTER, .T. ), "Alt+Enter is now enabled, try it"
   DO WHILE Inkey( 0 ) != K_ESC
      ? Row()
   ENDDO

   RETURN
