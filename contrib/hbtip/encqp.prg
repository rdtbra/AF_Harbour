/*
 * $Id: encqp.prg 15680 2010-10-23 09:07:01Z vszakats $
 */

/*
 * Harbour Project source code:
 * TIP quoted-printable encoder/decoder class
 *
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
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

CREATE CLASS TIPEncoderQP FROM TIPEncoder
   METHOD New() CONSTRUCTOR
   METHOD Encode( cData )
   METHOD Decode( cData )
ENDCLASS

METHOD New() CLASS TIPEncoderQP
   ::cName := "quoted-printable"
   RETURN Self

METHOD Encode( cData ) CLASS TIPEncoderQP
   LOCAL c
   LOCAL cString := ""
   LOCAL nLineLen := 0

   FOR EACH c IN cData
      IF c == Chr( 13 )
         cString += Chr( 13 ) + Chr( 10 )
         nLineLen := 0
      ELSEIF Asc( c ) > 126 .OR. ;
         c $ '=?!"#$@[\]^`{|}~' .OR. ;
         ( Asc( c ) < 32 .AND. !( c $ Chr( 13 ) + Chr( 10 ) + Chr( 9 ) ) ) .OR. ;
         ( c $ " " + Chr( 9 ) .AND. SubStr( cData, c:__enumIndex() + 1 ) $ Chr( 13 ) + Chr( 10 ) )
         IF nLineLen + 3 > 76
            cString += "=" + Chr( 13 ) + Chr( 10 )
            nLineLen := 0
         ENDIF
         cString += "=" + hb_NumToHex( Asc( c ), 2 )
         nLineLen += 3
      ELSEIF !( c == Chr( 10 ) )
         cString += c
         nLineLen += 1
      ENDIF
   NEXT

   RETURN cString

METHOD Decode( cData ) CLASS TIPEncoderQP
   LOCAL tmp
   LOCAL c
   LOCAL nLen
   LOCAL cString := ""

   /* delete soft line break. */
   cData := StrTran( cData, "=" + Chr( 13 ) + Chr( 10 ) )
   cData := StrTran( cData, "=" + Chr( 10 ) ) /* also delete non-standard line breaks */

   nLen := Len( cData )
   FOR tmp := 1 TO nLen
      c := SubStr( cData, tmp, 1 )
      IF c == "=" .AND. Len( SubStr( cData, tmp + 1, 2 ) ) == 2
         cString += Chr( hb_HexToNum( SubStr( cData, tmp + 1, 2 ) ) )
         tmp += 2
      ELSE
         cString += c
      ENDIF
   NEXT

   RETURN cString
