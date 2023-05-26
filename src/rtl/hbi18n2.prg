/*
 * $Id: hbi18n2.prg 16744 2011-05-09 18:07:27Z vszakats $
 */

/*
 * Harbour Project source code:
 * I18N helper functions to manage .pot files
 *
 * Copyright 2009 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
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

#include "common.ch"
#include "fileio.ch"

#define _I18N_NONE         0
#define _I18N_CONTEXT      1
#define _I18N_MSGID        2
#define _I18N_MSGSTR       3
#define _I18N_PLURAL       4
#define _I18N_SOURCE       5

#define _I18N_ITEM         { "", {}, {}, .F., NIL }

#define _I18N_EOL          chr( 10 )
#define _I18N_DELIM        ( chr( 0 ) + chr( 3 ) + chr( 0 ) )

#define LEFTEQUAL( l, r )  ( Left( l, Len( r ) ) == r )

STATIC FUNCTION __I18N_fileName( cFile )
   LOCAL cExt

   IF Set( _SET_DEFEXTENSIONS )
      hb_FNameSplit( cFile, NIL, NIL, @cExt )
      IF Empty( cExt )
         cFile += ".pot"
      ENDIF
   ENDIF
   RETURN cFile


STATIC FUNCTION __I18N_strEncode( cStr )
   RETURN substr( hb_strToExp( cStr, .T. ), 2 )


STATIC FUNCTION __I18N_strDecode( cLine, cValue, lCont )
   LOCAL lRet := .F.
   LOCAL cText

   cText := hb_strCdecode( cLine, @lCont )
   IF cText != NIL
      lRet := .T.
      IF cValue == NIL
         cValue := cText
      ELSE
         cValue += cText
      ENDIF
   ENDIF

   RETURN lRet

#define _UTF8_BOM e"\xEF\xBB\xBF"

FUNCTION __I18N_POTARRAYLOAD( cFile, cErrorMsg )
   LOCAL cLine, cValue
   LOCAL nMode, nIndex, nOldIndex, nLine, n
   LOCAL aTrans, aItem, aLines
   LOCAL lCont
   LOCAL hFile

   __I18N_fileName( @cFile )
   hFile := fopen( cFile, FO_READ )
   IF hFile == -1
      cErrorMsg := "cannot open file: " + cFile
      RETURN NIL
   ENDIF
   cValue := Space( fseek( hFile, 0, FS_END ) )
   fseek( hFile, 0, FS_SET )
   n := fread( hFile, @cValue, len( cValue ) )
   fclose( hFile )
   IF n != len( cValue )
      cErrorMsg := "cannot read from file: " + cFile
      RETURN NIL
   ENDIF
   /* Strip UTF-8 BOM */
   IF Left( cValue, Len( _UTF8_BOM ) ) == _UTF8_BOM
      cValue := SubStr( cValue, Len( _UTF8_BOM ) + 1 )
   ENDIF
   IF !hb_eol() == _I18N_EOL
      cValue := strtran( cValue, hb_eol(), _I18N_EOL )
   ENDIF
   IF !hb_eol() == chr( 13 ) + chr( 10 )
      cValue := strtran( cValue, chr( 13 ) + chr( 10 ), _I18N_EOL )
   ENDIF
   aLines := hb_aTokens( cValue, _I18N_EOL )

   lCont := .F.
   nLine := 0
   nIndex := 1
   nMode := _I18N_NONE
   aTrans := {}
   aItem := _I18N_ITEM
   cValue := NIL
   FOR EACH cLine IN aLines
      cLine := alltrim( cLine )
      ++nLine
      IF lCont
         cValue += hb_eol()
      ELSE
         IF LEFTEQUAL( cLine, "#" ) .AND. nMode == _I18N_NONE
            IF LEFTEQUAL( cLine, "#:" )   // source code references
               IF Empty( aItem[ _I18N_SOURCE ] )
                  aItem[ _I18N_SOURCE ] := ""
               ELSE
                  aItem[ _I18N_SOURCE ] += " "
               ENDIF
               aItem[ _I18N_SOURCE ] += strtran( ltrim( substr( cLine, 3 ) ), "\", "/" )
/*
            ELSEIF LEFTEQUAL( cLine, "#," )  // flags
               cLine := ltrim( substr( cLine, 3 ) )
               IF cLine == "c-format"
               ELSE
                  cErrorMsg := "unsupported flag: " + cLine
                  EXIT
               ENDIF
*/
            ENDIF
            cLine := ""
         ELSEIF LEFTEQUAL( cLine, "msgctxt " ) .AND. nMode == _I18N_NONE
            cLine := ltrim( substr( cLine, 9 ) )
            nMode := _I18N_CONTEXT
            cValue := NIL
         ELSEIF LEFTEQUAL( cLine, "msgid " ) .AND. ;
                ( nMode == _I18N_NONE .OR. nMode == _I18N_CONTEXT )
            nIndex := 1
            cLine := ltrim( substr( cLine, 7 ) )
            IF nMode == _I18N_CONTEXT
               IF cValue == NIL
                  cErrorMsg := "undefined msgctxt value"
                  EXIT
               ENDIF
               aItem[ _I18N_CONTEXT ] := cValue
            ENDIF
            nMode := _I18N_MSGID
            cValue := NIL
         ELSEIF LEFTEQUAL( cLine, "msgid_plural" ) .AND. nMode == _I18N_MSGID
            nOldIndex := nIndex
            nIndex := 2
            n := 13
            IF ISDIGIT( substr( cLine, n, 1 ) )
               nIndex := VAL( substr( cLine, n ) ) + 1
               IF nIndex < 1
                  cErrorMsg := "wrong plural form index"
                  EXIT
               ENDIF
               WHILE ISDIGIT( substr( cLine, n, 1 ) )
                  ++n
               ENDDO
            ENDIF
            IF nIndex != nOldIndex + 1
               cErrorMsg := "wrong plural form index"
               EXIT
            ENDIF
            IF cValue == NIL
               cErrorMsg := "undefined msgid value"
               EXIT
            ENDIF
            aItem[ _I18N_PLURAL ] := .T.
            AAdd( aItem[ _I18N_MSGID ], cValue )
            cLine := ltrim( substr( cLine, n ) )
            cValue := NIL
         ELSEIF LEFTEQUAL( cLine, "msgstr " ) .AND. nMode == _I18N_MSGID
            nIndex := 0
            cLine := ltrim( substr( cLine, 8 ) )
            nMode := _I18N_MSGSTR
            IF cValue == NIL
               cErrorMsg := "undefined msgid value"
               EXIT
            ENDIF
            AAdd( aItem[ _I18N_MSGID ], cValue )
            cValue := NIL
         ELSEIF LEFTEQUAL( cLine, "msgstr[" ) .AND. ;
                ( nMode == _I18N_MSGID .OR. nMode == _I18N_MSGSTR )
            nOldIndex := IIF( nMode == _I18N_MSGSTR, nIndex, -1 )
            nIndex := 0
            n := 8
            IF ISDIGIT( substr( cLine, n, 1 ) )
               nIndex := VAL( substr( cLine, n ) )
               WHILE ISDIGIT( substr( cLine, n, 1 ) )
                  ++n
               ENDDO
            ENDIF
            WHILE substr( cLine, n, 1 ) == " "
               ++n
            ENDDO
            IF !substr( cLine, n, 1 ) == "]"
               nIndex := -1
            ENDIF
            cLine := ltrim( substr( cLine, n + 1 ) )
            IF nIndex < 0 .OR. nIndex != nOldIndex + 1
               cErrorMsg := "wrong translation index"
               EXIT
            ENDIF
            IF cValue == NIL
               cErrorMsg := "undefined " + IIF( nMode == _I18N_MSGID, ;
                                                "msgid", "msgstr" ) + " value"
               EXIT
            ENDIF
            aItem[ _I18N_PLURAL ] := .T.
            AAdd( aItem[ nMode ], cValue )
            nMode := _I18N_MSGSTR
            cValue := NIL
         ELSEIF EMPTY( cLine ) .AND. nMode == _I18N_MSGSTR
            IF cValue == NIL
               cErrorMsg := "undefined msgstr value"
               EXIT
            ENDIF
            AAdd( aItem[ _I18N_MSGSTR ], cValue )
            AAdd( aTrans, aItem )
            aItem := _I18N_ITEM
            nMode := _I18N_NONE
            cValue := NIL
         ENDIF
      ENDIF

      IF lCont .OR. !EMPTY( cLine )
         IF ( nMode != _I18N_CONTEXT .AND. ;
              nMode != _I18N_MSGID .AND. ;
              nMode != _I18N_MSGSTR ) .OR. ;
            ! __I18N_strDecode( cLine, @cValue, @lCont )
            cErrorMsg := "unrecognized line"
            EXIT
         ENDIF
      ENDIF
   NEXT

   IF cErrorMsg == NIL
      IF lCont
         cErrorMsg := "unclosed string"
      ELSEIF nMode == _I18N_MSGSTR
         IF cValue == NIL
            cErrorMsg := "undefined msgstr value"
         ELSE
            AAdd( aItem[ _I18N_MSGSTR ], cValue )
            AAdd( aTrans, aItem )
         ENDIF
      ELSEIF nMode != _I18N_NONE
         cErrorMsg := "unclosed translation definition"
      ENDIF
   ENDIF
   IF cErrorMsg == NIL .AND. EMPTY( aTrans )
      cErrorMsg := "cannot find any translation rules"
   ENDIF

   IF cErrorMsg != NIL
      cErrorMsg := cFile + ":" + hb_nToS( nLine ) + ";" + cErrorMsg
      aTrans := NIL
   ENDIF

   RETURN aTrans


STATIC FUNCTION IsBOM_UTF8( cFileName )
   LOCAL fhnd := FOpen( cFileName, FO_READ )
   LOCAL cBuffer

   IF fhnd != F_ERROR
      cBuffer := Space( Len( _UTF8_BOM ) )
      FRead( fhnd, @cBuffer, Len( cBuffer ) )
      FClose( fhnd )
      IF cBuffer == _UTF8_BOM
         RETURN .T.
      ENDIF
   ENDIF

   RETURN .F.


FUNCTION __I18N_POTARRAYSAVE( cFile, aTrans, cErrorMsg, lVersionNo, lSourceRef )
   LOCAL aItem
   LOCAL hFile
   LOCAL lRet, lPlural
   LOCAL cEol, cPOT, cFlg
   LOCAL msg

   IF ! ISLOGICAL( lVersionNo )
      lVersionNo := .T.
   ENDIF
   IF ! ISLOGICAL( lSourceRef )
      lSourceRef := .T.
   ENDIF

   lRet := .F.
   cEol := hb_eol()
   cFlg := "#, c-format" + cEol
   cPOT := iif( hb_FileExists( cFile ) .AND. IsBOM_UTF8( cFile ), _UTF8_BOM + cEol, "" ) + ; /* Put it in separate line to less confuse non-BOM aware parsers */
           "#" + cEol + ;
           "# This file is generated by " + iif( lVersionNo, hb_version(), "Harbour" ) + cEol + ;
           "#" + cEol
   FOR EACH aItem IN aTrans
      cPOT += cEol
      IF lSourceRef .AND. !Empty( aItem[ _I18N_SOURCE ] )
         cPOT += "#: "
         cPOT += aItem[ _I18N_SOURCE ]
         cPOT += cEol
      ENDIF
      cPOT += cFlg
      IF ! aItem[ _I18N_CONTEXT ] == ""
         cPOT += "msgctxt "
         cPOT += __I18N_strEncode( aItem[ _I18N_CONTEXT ] )
         cPOT += cEol
      ENDIF
      FOR EACH msg IN aItem[ _I18N_MSGID ]
         IF msg:__enumIndex() == 1
            cPOT += "msgid "
         ELSEIF msg:__enumIndex() == 2
            cPOT += "msgid_plural "
         ELSE
            cPOT += "msgid_plural" + hb_nToS( msg:__enumIndex() - 1 ) + " "
         ENDIF
         cPOT += __I18N_strEncode( msg )
         cPOT += cEol
      NEXT
      lPlural := aItem[ _I18N_PLURAL ] .OR. Len( aItem[ _I18N_MSGSTR ] ) > 1
      FOR EACH msg IN aItem[ _I18N_MSGSTR ]
         IF lPlural
            cPOT += "msgstr[" + hb_nToS( msg:__enumIndex() - 1 ) + "] "
         ELSE
            cPOT += "msgstr "
         ENDIF
         cPOT += __I18N_strEncode( msg )
         cPOT += cEol
      NEXT
   NEXT

   __I18N_fileName( @cFile )
   hFile := fcreate( cFile )
   IF hFile == -1
      cErrorMsg := "cannot create translation file: " + cFile
   ELSEIF fwrite( hFile, cPOT, len( cPOT ) ) != len( cPOT )
      cErrorMsg := "cannot write to file: " + cFile
   ELSE
      lRet := .T.
   ENDIF
   fclose( hFile )

   RETURN lRet


FUNCTION __I18N_POTARRAYTOHASH( aTrans, lEmpty, hI18N )
   LOCAL aItem
   LOCAL cContext
   LOCAL hTrans, hContext

   IF ! HB_ISLOGICAL( lEmpty )
      lEmpty := .F.
   ENDIF
   IF ! HB_ISHASH( hI18N )
      hI18N := { "CONTEXT" => { "" => { => } } }
   ENDIF
   hTrans := hI18N[ "CONTEXT" ]

   FOR EACH aItem IN aTrans
      IF lEmpty .OR. !Empty( aItem[ _I18N_MSGSTR, 1 ] )
         cContext := aItem[ _I18N_CONTEXT ]
         IF ! cContext $ hTrans
            hTrans[ cContext ] := hContext := { => }
         ELSE
            hContext := hTrans[ cContext ]
         ENDIF
         IF Empty( aItem[ _I18N_MSGSTR, 1 ] )
            IF ! aItem[ _I18N_MSGID, 1 ] $ hContext
               hContext[ aItem[ _I18N_MSGID, 1 ] ] := IIF( aItem[ _I18N_PLURAL ], ;
                        AClone( aItem[ _I18N_MSGID ] ), aItem[ _I18N_MSGID, 1 ] )
            ENDIF
         ELSE
            hContext[ aItem[ _I18N_MSGID, 1 ] ] := IIF( aItem[ _I18N_PLURAL ], ;
                     AClone( aItem[ _I18N_MSGSTR ] ), aItem[ _I18N_MSGSTR, 1 ] )
         ENDIF
      ENDIF
   NEXT

   RETURN hI18N


FUNCTION __I18N_POTARRAYTRANS( aTrans, hI18N )
   LOCAL aItem
   LOCAL hContext
   LOCAL cContext
   LOCAL hTrans
   LOCAL xTrans

   hTrans := hI18N[ "CONTEXT" ]

   FOR EACH aItem IN aTrans
      cContext := aItem[ _I18N_CONTEXT ]
      IF cContext $ hTrans
         hContext := hTrans[ cContext ]
         IF Empty( aItem[ _I18N_MSGSTR, 1 ] )
            IF aItem[ _I18N_MSGID, 1 ] $ hContext
               xTrans := hContext[ aItem[ _I18N_MSGID, 1 ] ]
               IF aItem[ _I18N_PLURAL ]
                  aItem[ _I18N_MSGSTR ] := IIF( HB_ISARRAY( xTrans ), ;
                                                AClone( xTrans ), { xTrans } )
               ELSE
                  aItem[ _I18N_MSGSTR ] := IIF( HB_ISARRAY( xTrans ), ;
                                                { xTrans[ 1 ] }, { xTrans } )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT

   RETURN aTrans


FUNCTION __I18N_HASHJOIN( hTrans, hTrans2 )
   LOCAL hContext, hCtx, hDstCtx
   LOCAL xTrans

   hContext := hTrans[ "CONTEXT" ]
   FOR EACH hCtx in hTrans2[ "CONTEXT" ]
      IF ! hCtx:__enumKey() $ hContext
         hContext[ hCtx:__enumKey() ] := hb_hClone( hCtx )
      ELSE
         hDstCtx := hContext[ hCtx:__enumKey() ]
         FOR EACH xTrans IN hCtx
            IF !Empty( xTrans ) .AND. ;
               ( ! xTrans:__enumKey() $ hDstCtx .OR. ;
                 Empty( hDstCtx[ xTrans:__enumKey() ] ) )
               hDstCtx[ xTrans:__enumKey() ] := IIF( HB_ISARRAY( xTrans ), ;
                                                     AClone( xTrans ), xTrans )
            ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN hTrans


FUNCTION __I18N_POTARRAYJOIN( aTrans, aTrans2, hIndex )
   LOCAL aItem, aDest, aSrc
   LOCAL ctx

   IF !HB_ISHASH( hIndex )
      hIndex := { => }
      FOR EACH aItem in aTrans
         ctx := aItem[ _I18N_CONTEXT ] + _I18N_DELIM + aItem[ _I18N_MSGID, 1 ]
         hIndex[ ctx ] := aItem:__enumIndex()
      NEXT
   ENDIF

   FOR EACH aItem in aTrans2
      ctx := aItem[ _I18N_CONTEXT ] + _I18N_DELIM + aItem[ _I18N_MSGID, 1 ]
      IF ! ctx $ hIndex
         AAdd( aTrans, AClone( aItem ) )
         hIndex[ ctx ] := Len( aTrans )
      ELSE
         aDest := aTrans[ hIndex[ ctx ] ]
         IF aItem[ _I18N_PLURAL ]
            aDest[ _I18N_PLURAL ] := .T.
         ENDIF
         IF !Empty( aItem[ _I18N_SOURCE ] )
            IF Empty( aDest[ _I18N_SOURCE ] )
               aDest[ _I18N_SOURCE ] := aItem[ _I18N_SOURCE ]
            ELSE
               aSrc := hb_aTokens( aDest[ _I18N_SOURCE ] )
               FOR EACH ctx IN hb_aTokens( aItem[ _I18N_SOURCE ] )
                  IF Ascan( aSrc, ctx,,, .T. ) == 0
                     aDest[ _I18N_SOURCE ] += " "
                     aDest[ _I18N_SOURCE ] += ctx
                  ENDIF
               NEXT
            ENDIF
         ENDIF
         IF !Empty( aItem[ _I18N_MSGSTR ] ) .AND. ;
            ( Empty( aDest[ _I18N_MSGSTR ] ) .OR. ;
              ( LEN( aDest[ _I18N_MSGSTR ] ) == 1 .AND. ;
                Empty( aDest[ _I18N_MSGSTR, 1 ] ) ) )
            aDest[ _I18N_MSGSTR ] := AClone( aItem[ _I18N_MSGSTR ] )
         ENDIF
      ENDIF
   NEXT

   RETURN aTrans


FUNCTION HB_I18N_LOADPOT( cFile, pI18N, cErrorMsg )
   LOCAL aTrans
   LOCAL hI18N

   aTrans := __I18N_POTARRAYLOAD( cFile, @cErrorMsg )
   IF aTrans != NIL
      IF HB_ISPOINTER( pI18N )
         hI18N := __I18N_HASHTABLE( pI18N )
      ENDIF
      IF hI18N == NIL
         pI18N := __I18N_HASHTABLE( __I18N_POTARRAYTOHASH( aTrans ) )
      ELSE
         __I18N_POTARRAYTOHASH( aTrans, __I18N_HASHTABLE( pI18N ) )
      ENDIF
   ENDIF

   RETURN pI18N


FUNCTION HB_I18N_SAVEPOT( cFile, pI18N, cErrorMsg )
   LOCAL hI18N
   LOCAL hFile
   LOCAL lRet := .T.
   LOCAL cEol, cPOT, cFlg
   LOCAL context, trans, msgctxt, msgstr

   IF HB_ISPOINTER( pI18N )
      hI18N := __I18N_HASHTABLE( pI18N )
   ENDIF
   IF hI18N == NIL
      cErrorMsg := "wrong translation set item"
      lRet := .F.
   ELSE
      cEol := hb_eol()
      cFlg := "#, c-format" + cEol
      cPOT := "#" + cEol + ;
              "# This file is generated by " + hb_version() + cEol + ;
              "#" + cEol
      FOR EACH context IN hI18N[ "CONTEXT" ]
         msgctxt := IIF( context:__enumKey() == "", NIL, ;
                  "msgctxt " + __I18N_strEncode( context:__enumKey() ) + cEol )
         FOR EACH trans IN context
            cPOT += cEol + cFlg
            IF msgctxt != NIL
               cPOT += msgctxt
            ENDIF
            cPOT += "msgid "
            cPOT += __I18N_strEncode( trans:__enumKey() )
            cPOT += cEol
            IF valtype( trans ) == "A"
               FOR EACH msgstr IN trans
                  cPOT += "msgstr["
                  cPOT += hb_nToS( msgstr:__enumIndex() - 1 )
                  cPOT += "] "
                  cPOT += __I18N_strEncode( msgstr )
                  cPOT += cEol
               NEXT
            ELSE
               cPOT += "msgstr "
               cPOT += __I18N_strEncode( trans )
               cPOT += cEol
            ENDIF
         NEXT
      NEXT

      __I18N_fileName( @cFile )
      hFile := fcreate( cFile )
      IF hFile == -1
         cErrorMsg := "cannot create translation file: " + cFile
         lRet := .F.
      ELSEIF fwrite( hFile, cPOT, len( cPOT ) ) != len( cPOT )
         cErrorMsg := "cannot write to file: " + cFile
         lRet := .F.
      ENDIF
      fclose( hFile )

   ENDIF

   RETURN lRet
