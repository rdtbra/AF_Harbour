/*
 * $Id: httpcli.prg 16723 2011-05-06 11:40:32Z vszakats $
 */

/*
 * xHarbour Project source code:
 * TIP Class oriented Internet protocol library (HTTP)
 *
 * Copyright 2003 Giancarlo Niccolai <gian@niccolai.ws>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbclass.ch"

#include "common.ch"
#include "fileio.ch"

CREATE CLASS tIPClientHTTP FROM tIPClient

   VAR cMethod
   VAR nReplyCode
   VAR cReplyDescr
   VAR nVersion     INIT 1
   VAR nSubversion  INIT 0
   VAR bChunked
   VAR hHeaders     INIT { => }
   VAR hCookies     INIT { => }
   VAR hFields      INIT { => }
   VAR cUserAgent   INIT "Mozilla/3.0 compatible"
   VAR cAuthMode    INIT ""
   VAR cBoundary
   VAR aAttachments INIT {}

   METHOD New( oUrl, bTrace, oCredentials )
   METHOD Get( cQuery )
   METHOD Post( xPostData, cQuery )
   METHOD ReadHeaders( lClear )
   METHOD Read( nLen )
   METHOD UseBasicAuth()      INLINE   ::cAuthMode := "Basic"
   METHOD ReadAll()
   METHOD SetCookie
   METHOD GetCookies
   METHOD Boundary
   METHOD Attach( cName, cFileName, cType )
   METHOD PostMultiPart( xPostData, cQuery )
   METHOD WriteAll( cFile )

   HIDDEN:

   METHOD StandardFields()

ENDCLASS

METHOD New( oUrl, bTrace, oCredentials ) CLASS tIPClientHTTP

   LOCAL oLog

   IF ISLOGICAL( bTrace ) .AND. bTrace
      oLog := tIPLog():New( "http" )
      bTrace := {| cMsg | iif( PCount() > 0, oLog:Add( cMsg ), oLog:Close() ) }
   ENDIF

   ::super:new( oUrl, bTrace, oCredentials )

   ::nDefaultPort := iif( ::oUrl:cProto == "https", 443, 80 )
   ::nConnTimeout := 5000
   ::bChunked     := .F.

   hb_HCaseMatch( ::hHeaders, .F. )

   RETURN Self

METHOD Get( cQuery ) CLASS tIPClientHTTP

   IF ! hb_isString( cQuery )
      cQuery := ::oUrl:BuildQuery()
   ENDIF

   ::InetSendall( ::SocketCon, "GET " + cQuery + " HTTP/1.1" + ::cCRLF )
   ::StandardFields()
   ::InetSendall( ::SocketCon, ::cCRLF )
   IF ::InetErrorCode( ::SocketCon ) ==  0
      RETURN ::ReadHeaders()
   ENDIF

   RETURN .F.

METHOD Post( xPostData, cQuery ) CLASS tIPClientHTTP
   LOCAL cData, nI, cTmp, y

   IF hb_isHash( xPostData )
      cData := ""
      y := Len( xPostData )
      FOR nI := 1 TO y
         cTmp := tip_URLEncode( AllTrim( hb_cStr( hb_HKeyAt( xPostData, nI ) ) ) )
         cData += cTmp + "="
         cTmp := tip_URLEncode( hb_cStr( hb_HValueAt( xPostData, nI ) ) )
         cData += cTmp
         IF nI != y
            cData += "&"
         ENDIF
      NEXT
   ELSEIF hb_isArray( xPostData )
      cData := ""
      y := Len( xPostData )
      FOR nI := 1 TO y
         cTmp := tip_URLEncode( AllTrim( hb_cStr( xPostData[ nI, 1 ] ) ) )
         cData += cTmp + "="
         cTmp := tip_URLEncode( hb_cStr( xPostData[ nI, 2 ] ) )
         cData += cTmp
         IF nI != y
            cData += "&"
         ENDIF
      NEXT
   ELSEIF hb_isString( xPostData )
      cData := xPostData
   ELSE
      RETURN .F.
   ENDIF

   IF ! hb_isString( cQuery )
      cQuery := ::oUrl:BuildQuery()
   ENDIF

   ::InetSendall( ::SocketCon, "POST " + cQuery + " HTTP/1.1" + ::cCRLF )
   ::StandardFields()

   IF ! "Content-Type" $ ::hFields
      ::InetSendall( ::SocketCon, e"Content-Type: application/x-www-form-urlencoded\r\n" )
   ENDIF

   ::InetSendall( ::SocketCon, "Content-Length: " + ;
         hb_ntos( Len( cData ) ) + ::cCRLF )

   // End of header
   ::InetSendall( ::SocketCon, ::cCRLF )

   IF ::InetErrorCode( ::SocketCon  ) ==  0
      ::InetSendall( ::SocketCon, cData )
      ::bInitialized := .T.
      RETURN ::ReadHeaders()
   ENDIF

   RETURN .F.

METHOD StandardFields() CLASS tIPClientHTTP
   LOCAL iCount
   LOCAL oEncoder,cCookies

   ::InetSendall( ::SocketCon, "Host: " + ::oUrl:cServer + ::cCRLF )
   ::InetSendall( ::SocketCon, "User-agent: " + ::cUserAgent + ::cCRLF )
   ::InetSendall( ::SocketCon, "Connection: close" + ::cCRLF )

   // Perform a basic authentication request
   IF ::cAuthMode == "Basic" .AND. ! ("Authorization" $ ::hFields)
      oEncoder := TIPEncoderBase64():New()
      oEncoder:bHttpExcept := .T.
      ::InetSendall( ::SocketCon, "Authorization: Basic " +;
          oEncoder:Encode(  ::oUrl:cUserID + ":" + ::oUrl:cPassword ) + ::cCRLF )
   ENDIF


   // send cookies
   cCookies:=::getCookies()
   IF ! Empty( cCookies )
      ::InetSendall( ::SocketCon, "Cookie: " + cCookies+::cCRLF)
   ENDIF

   //Send optional Fields
   FOR iCount := 1 TO Len( ::hFields )
      ::InetSendall( ::SocketCon, hb_HKeyAt( ::hFields, iCount ) +;
         ": " + hb_HValueAt( ::hFields, iCount ) + ::cCRLF )
   NEXT

   RETURN .T.

METHOD ReadHeaders( lClear ) CLASS tIPClientHTTP
   LOCAL cLine, nPos, aVersion
   LOCAL aHead

   // Now reads the fields and set the content lenght
   cLine := ::InetRecvLine( ::SocketCon, @nPos, 500 )
   IF Empty( cLine )
      // In case of timeout or error on receiving
      RETURN .F.
   ENDIF

   // Get Protocol version
   aVersion := hb_regex( "^HTTP/(.)\.(.) ([0-9][0-9][0-9]) +(.*)$", cLine )
   ::cReply := cLine

   IF Empty( aVersion )
      ::nVersion := 0
      ::nSubversion := 9
      ::nReplyCode := 0
      ::cReplyDescr := ""
   ELSE
      ::nVersion := Val( aVersion[ 2 ] )
      ::nSubversion := Val( aVersion[ 3 ] )
      ::nReplyCode := Val( aVersion[ 4 ] )
      ::cReplyDescr := aVersion[ 5 ]
   ENDIF

   ::nLength := -1
   ::bChunked := .F.
   cLine := ::InetRecvLine( ::SocketCon, @nPos, 500 )
   IF ! lClear == .F. .AND. ! Empty( ::hHeaders )
      ::hHeaders := { => }
   ENDIF
   DO WHILE ::InetErrorCode( ::SocketCon ) == 0 .AND. ! Empty( cLine )
      aHead := hb_regexSplit( ":", cLine,,, 1 )
      IF aHead == NIL .OR. Len( aHead ) != 2
         cLine := ::InetRecvLine( ::SocketCon, @nPos, 500 )
         LOOP
      ENDIF

      ::hHeaders[ aHead[ 1 ] ] := LTrim( aHead[ 2 ] )

      DO CASE
      // RFC 2068 forces to discard content length on chunked encoding
      CASE Lower( aHead[ 1 ] ) == "content-length" .AND. ! ::bChunked
         cLine := SubStr( cLine, 16 )
         ::nLength := Val( cLine )

      // as above
      CASE Lower( aHead[ 1 ] ) == "transfer-encoding"
         IF At( "chunked", Lower( cLine ) ) > 0
            ::bChunked := .T.
            ::nLength := -1
         ENDIF
      CASE Lower( aHead[ 1 ] ) == "set-cookie"
         ::setCookie( aHead[ 2 ] )
      ENDCASE

      cLine := ::InetRecvLine( ::SocketCon, @nPos, 500 )
   ENDDO
   IF ::InetErrorCode( ::SocketCon ) != 0
      RETURN .F.
   ENDIF
   RETURN .T.

METHOD Read( nLen ) CLASS tIPClientHTTP
   LOCAL cData, nPos, cLine, aHead

   IF ! ::bInitialized
      ::bInitialized := .T.
      IF ! ::Get()
         RETURN NIL
      ENDIF
   ENDIF

   /* On HTTP/1.1 protocol, content lenght can be in hex format before each chunk.
      The chunk header is read each time nLength is -1; While reading the chunk,
      nLenght is set to nRead plus the expected chunk size. After reading the
      chunk, the footer is discarded, and nLenght is reset to -1.
   */
   IF ::nLength == -1 .AND. ::bChunked
      cLine := ::InetRecvLine( ::SocketCon, @nPos, 1024 )

      IF Empty( cLine )
         RETURN NIL
      ENDIF

      // if this is the last chunk ...
      IF cLine == "0"

         // read the footers.
         cLine := ::InetRecvLine( ::SocketCon, @nPos, 1024 )
         DO WHILE ! Empty( cLine )
            // add Headers to footers
            aHead := hb_regexSplit( ":", cLine,,, 1 )
            IF aHead != NIL
               ::hHeaders[ aHead[1] ] := LTrim(aHead[2])
            ENDIF

            cLine := ::InetRecvLine( ::SocketCon, @nPos, 1024 )
         ENDDO

         // we are done
         ::bEof := .T.
         RETURN NIL
      ENDIF

      // A normal chunk here

      // Remove the extensions
      nPos := At( ";", cLine )
      IF nPos > 0
         cLine := SubStr( cLine, 1, nPos - 1 )
      ENDIF

      // Convert to length
      // Set length so that super::Read reads in at max cLine bytes.
      ::nLength := hb_HexToNum( cLine ) + ::nRead

   ENDIF

   // nLen is normalized by super:read()
   cData := ::super:Read( nLen )

   // If bEof is set with chunked encoding, this means that the whole chunk has been read;
   IF ::bEof .AND. ::bChunked
      ::bEof := .F.
      ::nLength := -1
     //chunked data is followed by a blank line
     /* cLine := */ ::InetRecvLine( ::SocketCon, @nPos, 1024 )

   ENDIF

   RETURN cData

METHOD ReadAll() CLASS tIPClientHTTP

   LOCAL cOut := "", cChunk
   IF ! ::bInitialized
      ::bInitialized := .T.
      IF ! ::Get()
         RETURN NIL
      ENDIF
   ENDIF
   IF ::bChunked
      cChunk:=::read()
      DO WHILE cChunk != NIL
         cOut += cChunk
      // ::nLength := -1
         cChunk := ::read()
      ENDDO
   ELSE
      RETURN ::read()
   ENDIF
   RETURN cOut

METHOD setCookie( cLine ) CLASS tIPClientHTTP
   //docs from http://www.ietf.org/rfc/rfc2109.txt
   LOCAL aParam
   LOCAL cHost, cPath, cName, cValue, aElements, cElement
   LOCAL cDefaultHost := ::oUrl:cServer, cDefaultPath := ::oUrl:cPath
   LOCAL x, y
   IF Empty( cDefaultPath )
      cDefaultPath := "/"
   ENDIF
   //this function currently ignores expires, secure and other tags that may be in the cookie for now...
//   ?"Setting COOKIE:",cLine
   aParam := hb_regexSplit( ";", cLine )
   cName := cValue := ""
   cHost := cDefaultHost
   cPath := cDefaultPath
   y := Len( aParam )
   FOR x := 1 to y
      aElements := hb_regexSplit( "=", aParam[ x ], 1 )
      IF Len( aElements ) == 2
         IF x == 1
            cName := AllTrim( aElements[ 1 ] )
            cValue := AllTrim( aElements[ 2 ] )
         ELSE
            cElement := Upper( AllTrim( aElements[ 1 ] ) )
            DO CASE
            //CASE cElement == "EXPIRES"
            CASE cElement == "PATH"
               cPath := AllTrim( aElements[ 2 ] )
            CASE cElement == "DOMAIN"
               cHost := AllTrim( aElements[ 2 ] )
            ENDCASE
         ENDIF
      ENDIF
   NEXT
   IF ! Empty( cName )
      //cookies are stored in hashes as host.path.name
      //check if we have a host hash yet
      IF ! hb_HHasKey( ::hCookies, cHost )
         ::hCookies[ cHost ] := { => }
      ENDIF
      IF ! hb_HHasKey( ::hCookies[ cHost ], cPath )
         ::hCookies[ cHost ][ cPath ] := { => }
      ENDIF
      ::hCookies[ cHost ][ cPath ][ cName ] := cValue
   ENDIF
   RETURN NIL

METHOD getcookies( cHost, cPath ) CLASS tIPClientHTTP
   LOCAL x, y, aDomKeys := {}, aKeys, z, cKey, aPathKeys, nPath
   LOCAL a, b, cOut := "", c, d

   DEFAULT cHost TO ::oUrl:cServer

   IF cPath == NIL
      cPath := ::oUrl:cPath
      IF Empty( cPath )
         cPath := "/"
      ENDIF
   ENDIF
   IF Empty( cHost )
      RETURN cOut
   ENDIF

   //tail matching the domain
   aKeys := hb_Hkeys( ::hCookies )
   y := Len( aKeys )
   z := Len( cHost )
   cHost := Upper( cHost )
   FOR x := 1 TO y
      cKey := Upper( aKeys[ x ] )
      IF Upper( right( cKey, z ) ) == cHost .AND. ( Len( cKey ) == z .OR. SubStr( aKeys[ x ], 0 - z, 1 ) == "." )
         AAdd( aDomKeys, aKeys[ x ] )
      ENDIF
   NEXT
   //more specific paths should be sent before lesser generic paths.
   ASort( aDomKeys,,, {| cX, cY | Len( cX ) > Len( cY ) } )
   y := Len( aDomKeys )
   //now that we have the domain matches we have to do path matchine
   nPath := Len( cPath )
   FOR x := 1 TO y
      aKeys := hb_Hkeys( ::hCookies[ aDomKeys[ x ] ] )
      aPathKeys := {}
      b := Len( aKeys )
      FOR a := 1 TO b
         cKey := aKeys[ a ]
         z := Len( cKey )
         IF cKey == "/" .OR. ( z <= nPath .AND. SubStr( cKey, 1, nPath ) == cKey )
            AAdd( aPathKeys, aKeys[ a ] )
         ENDIF
      NEXT
      ASort( aPathKeys,,, {| cX, cY | Len( cX ) > Len( cY ) } )
      b := Len( aPathKeys )
      FOR a := 1 TO b
         aKeys := hb_Hkeyat( ::hCookies[ aDomKeys[ x ] ] [ aPathKeys[ a ] ] )
         d := Len( aKeys )
         FOR c := 1 TO d
            IF ! Empty( cOut )
               cOut += "; "
            ENDIF
            cOut += aKeys[ c ] + "=" + ::hCookies[ aDomKeys[ x ] ][ aPathKeys[ a ] ][ aKeys[ c ] ]
         NEXT
      NEXT
   NEXT
   RETURN cOut

METHOD Boundary( nType ) CLASS tIPClientHTTP
   /*
   nType: 0=as found as the separator in the stdin stream
          1=as found as the last one in the stdin stream
          2=as found in the CGI enviroment
   Examples:
   -----------------------------41184676334  //in the body or stdin stream
   -----------------------------41184676334--   //last one of the stdin stream
   ---------------------------41184676334 //in the header or CGI envirnment
   */

   LOCAL cBound := ::cBoundary
   LOCAL i
   DEFAULT nType TO 0
   IF Empty( cBound )
      cBound := Replicate( "-", 27 ) + Space( 11 )
      FOR i := 28 TO 38
         cBound := Stuff( cBound, i, 1, Str( Int( hb_Random( 0, 9 ) ), 1, 0 ) )
      NEXT
      ::cBoundary := cBound
   ENDIF
   cBound := iif( nType < 2, "--", "" ) + cBound + iif( nType == 1, "--", "" )
   RETURN cBound

METHOD Attach( cName, cFileName, cType ) CLASS tIPClientHTTP
   AAdd( ::aAttachments, { cName, cFileName, cType } )
   RETURN NIL

METHOD PostMultiPart( xPostData, cQuery ) CLASS tIPClientHTTP
   LOCAL cData := "", nI, cTmp, y, cBound := ::boundary()
   LOCAL cCrlf := ::cCRlf, oSub
   LOCAL nPos
   LOCAL cFilePath, cName, cFile, cType
   LOCAL nFile, cBuf, nBuf, nRead

   IF Empty( xPostData )
   ELSEIF hb_isHash( xPostData )
      y := Len( xPostData )
      FOR nI := 1 TO y
         cTmp := tip_URLEncode( AllTrim( hb_cStr( hb_HKeyAt( xPostData, nI ) ) ) )
         cData += cBound + cCrlf + 'Content-Disposition: form-data; name="' + cTmp + '"' + cCrlf + cCrLf
         cTmp := tip_URLEncode( AllTrim( hb_cStr( hb_HValueAt( xPostData, nI ) ) ) )
         cData += cTmp + cCrLf
      NEXT
   ELSEIF hb_isArray( xPostData )
      y := Len( xPostData )
      FOR nI := 1 TO y
         cTmp := tip_URLEncode( AllTrim( hb_cStr( xPostData[ nI, 1 ] ) ) )
         cData += cBound + cCrlf + 'Content-Disposition: form-data; name="' + cTmp + '"' + cCrlf + cCrLf
         cTmp := tip_URLEncode( AllTrim( hb_cStr( xPostData[ nI, 2 ] ) ) )
         cData += cTmp + cCrLf
      NEXT

   ELSEIF hb_isString( xPostData )
      cData := xPostData
   ENDIF

   FOR EACH oSub IN ::aAttachments
      cName := oSub[ 1 ]
      cFile := oSub[ 2 ]
      cType := oSub[ 3 ]
      cTmp := StrTran( cFile, "/", "\" )
      IF ( nPos := RAt( "\", cTmp ) ) != 0
          cFilePath := Left( cTmp, nPos )
      ELSEIF ( nPos := RAt( ":", cTmp ) ) != 0
          cFilePath := Left( cTmp, nPos )
      ELSE
          cFilePath := ""
      ENDIF
      cTmp := SubStr( cFile, Len( cFilePath ) + 1 )
      IF Empty( cType )
         cType := "text/html"
      ENDIF
      cData += cBound + cCrlf + 'Content-Disposition: form-data; name="' + cName + '"; filename="' + cTmp + '"' + cCrlf + 'Content-Type: ' + cType + cCrLf + cCrLf
      //hope this is not a big file....
      nFile := FOpen( cFile )
      /* TOFIX: Error checking on nFile. [vszakats] */
      nbuf := 8192
      nRead := nBuf
      //cBuf := Space( nBuf )
      DO WHILE nRead == nBuf
         // nRead := FRead( nFile, @cBuf, nBuf )
         cBuf := FReadStr( nFile, nBuf )
         nRead := Len( cBuf )
/*       IF nRead < nBuf
            cBuf := PadR( cBuf, nRead )
         ENDIF
*/
         cData += cBuf
      ENDDO
      FClose( nFile )
      cData += cCrlf
   NEXT
   cData += cBound + "--" + cCrlf
   IF ! hb_isString( cQuery )
      cQuery := ::oUrl:BuildQuery()
   ENDIF

   ::InetSendall( ::SocketCon, "POST " + cQuery + " HTTP/1.1" + ::cCRLF )
   ::StandardFields()

   IF ! "Content-Type" $ ::hFields
      ::InetSendall( ::SocketCon, e"Content-Type: multipart/form-data; boundary=" + ::boundary( 2 ) + ::cCrlf )
   ENDIF

   ::InetSendall( ::SocketCon, "Content-Length: " + hb_ntos( Len( cData ) ) + ::cCRLF )
   // End of header
   ::InetSendall( ::SocketCon, ::cCRLF )

   IF ::InetErrorCode( ::SocketCon  ) ==  0
      ::InetSendall( ::SocketCon, cData )
      ::bInitialized := .T.
      RETURN ::ReadHeaders()
   ENDIF

   RETURN .F.

METHOD WriteAll( cFile ) CLASS tIPClientHTTP

   LOCAL nFile
   LOCAL lSuccess

   LOCAL nLen
   LOCAL cStream

   IF ( nFile := FCreate( cFile ) ) != F_ERROR
      cStream := ::ReadAll()
      nLen := Len( cStream )
      lSuccess := ( FWrite( nFile, cStream, nLen ) == nLen )
      FClose( nFile )
   ELSE
      lSuccess := .F.
   ENDIF

   RETURN lSuccess
