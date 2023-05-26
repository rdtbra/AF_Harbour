/*
 * $Id: dnldftp.prg 16425 2011-03-04 12:09:57Z vszakats $
 */

/*
 * Download an file from an ftp server
 */

#include "common.ch"

PROCEDURE MAIN( cFile )

   ? TRP20FTPEnv( cFile )

   RETURN

   /**********************************************************************
    *
    *     Static Function TRP20FTPEnv()
    *
    **********************************************************************/

STATIC FUNCTION TRP20FTPEnv( cCarpeta )

   LOCAL aFiles
   LOCAL cUrl
   LOCAL cStr
   LOCAL lRetorno  := .T.
   LOCAL oUrl
   LOCAL oFTP
   LOCAL cUser
   LOCAL cServer
   LOCAL cPassword
   LOCAL cFile     := ""

   cServer   := "ftpserver"   /* change ftpserver to the real name  or ip of your ftp server */
   cUser     := "ftpuser"     /* change ftpuser to an valid user on ftpserer */
   cPassword := "ftppass"     /* change ftppass  to an valid password for ftpuser */
   cUrl      := "ftp://" + cUser + ":" + cPassword + "@" + cServer

   /* Leemos ficheros a enviar */
   aFiles := { { cCarpeta, 1, 2, 3 } }
   /* aFiles := Directory( cCarpeta ) */

   IF Len( aFiles ) > 0

      oUrl              := tUrl():New( cUrl )
      oFTP              := tIPClientFtp():New( oUrl, .T. )
      oFTP:nConnTimeout := 20000
      oFTP:bUsePasv     := .T.

      /* Comprobamos si el usuario contiene una @ para forzar el userid */
      IF At( "@", cUser ) > 0
         oFTP:oUrl:cServer   := cServer
         oFTP:oUrl:cUserID   := cUser
         oFTP:oUrl:cPassword := cPassword
      ENDIF

      IF oFTP:Open( cUrl )
         FOR EACH cFile IN afiles
            IF !oFtp:DownloadFile( cFile[ 1 ] )
               lRetorno := .F.
               EXIT
            ELSE
               lRetorno := .T.
            ENDIF
         NEXT
         oFTP:Close()
      ELSE
         cStr := "No se ha podido conectar con el servidor FTP" + " " + oURL:cServer
         IF oFTP:SocketCon == NIL
            cStr += Chr( 13 ) + Chr( 10 ) + "Conexi�n no inicializada"
         ELSEIF hb_InetErrorCode( oFTP:SocketCon ) == 0
            cStr += Chr( 13 ) + Chr( 10 ) + "Respuesta del servidor:" + " " + oFTP:cReply
         ELSE
            cStr += Chr( 13 ) + Chr( 10 ) + "Error en la conexi�n:" + " " + hb_InetErrorDesc( oFTP:SocketCon )
         ENDIF
         ? cStr
         lRetorno := .F.
      ENDIF
   ENDIF

   RETURN lRetorno
