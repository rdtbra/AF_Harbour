/*
 * $Id: hbqt_misc.prg 16670 2011-04-26 10:11:18Z vouchcac $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009 Pritpal Bedi <pritpal@vouchcac.com>
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
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "error.ch"
#include "hbtrace.ch"

/*----------------------------------------------------------------------*/

CREATE CLASS HbQtObjectHandler

   VAR    pPtr     /* TODO: Rename to __pPtr */

   VAR    __pSlots                                           PROTECTED
   VAR    __pEvents                                          PROTECTED

   //METHOD fromPointer( pPtr )
   METHOD hasValidPointer()

   METHOD connect( cnEvent, bBlock )
   METHOD disconnect( cnEvent )
   DESTRUCTOR _destroy()

   ERROR HANDLER onError()

ENDCLASS

/*----------------------------------------------------------------------*/

/* TODO: Drop this function, as it's not desired to have invalid QT pointers wrapped
         into valid .prg level QT objects.
         Currently it will return .F. for objects created using :fromPointer() */
METHOD HbQtObjectHandler:hasValidPointer()
   RETURN __hbqt_isPointer( ::pPtr )

/*----------------------------------------------------------------------*/

METHOD HbQtObjectHandler:onError()
   LOCAL cMsg := __GetMessage()
   LOCAL oError

   IF SubStr( cMsg, 1, 1 ) == "_"
      cMsg := SubStr( cMsg, 2 )
   ENDIF
   cMsg := "Message not found :" + cMsg

   oError := ErrorNew()

   oError:severity    := ES_ERROR
   oError:genCode     := EG_NOMETHOD
   oError:subSystem   := "HBQT"
   oError:subCode     := 1000
   oError:canRetry    := .F.
   oError:canDefault  := .F.
   oError:Args        := hb_AParams()
   oError:operation   := ProcName()
   oError:Description := cMsg

   Eval( ErrorBlock(), oError )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD HbQtObjectHandler:connect( cnEvent, bBlock )
   LOCAL nResult

   IF ! hb_isBlock( bBlock )
      RETURN .f.
   ENDIF

   SWITCH ValType( cnEvent )
   CASE "C"

      IF Empty( ::__pSlots )
         ::__pSlots := HBQSlots( Self )
      ENDIF
      nResult := ::__pSlots:hbconnect( Self, cnEvent, bBlock )

      SWITCH nResult
      CASE 0
         RETURN .T.
      CASE 8 /* QT connect call failure */
         RETURN .F.
      ENDSWITCH
      EXIT

   CASE "N"
      IF Empty( ::__pEvents )
         ::__pEvents := HBQEvents( Self )
      ENDIF
      nResult := ::__pEvents:hbConnect( Self, cnEvent, bBlock )

      SWITCH nResult
      CASE 0
         RETURN .T.
      CASE -3 /* bBlock not supplied */
         RETURN .F.
      ENDSWITCH
      EXIT

   OTHERWISE
      nResult := 99
   ENDSWITCH

   __hbqt_error( 1200 + nResult )

   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtObjectHandler:disconnect( cnEvent )

   LOCAL nResult := 0
   SWITCH ValType( cnEvent )
   CASE "C"
      IF ! empty( ::__pSlots )
         nResult := ::__pSlots:hbdisconnect( Self, cnEvent )
      ENDIF

      SWITCH nResult
      CASE 0
      CASE 4 /* signal not found in object */
      CASE 5 /* disconnect failure */
         RETURN .T.
      CASE 1 /* wrong slot container, no connect was called yet */
      CASE 2 /* object has been already freed */
      CASE 3 /* event not found */
         RETURN .F.
      ENDSWITCH
      EXIT

   CASE "N"
      IF ! empty( ::__pEvents )
         nResult := ::__pEvents:hbdisconnect( Self, cnEvent )
      ENDIF

      SWITCH nResult
      CASE 0
         RETURN .T.
      CASE -3 /* event not found */
      CASE -2 /* event not found */
      CASE -1 /* event not found */
         RETURN .F.
      ENDSWITCH
      EXIT

   OTHERWISE
      nResult := 99
   ENDSWITCH

   __hbqt_error( 1300 + nResult )
   RETURN .F.

/*----------------------------------------------------------------------*/

METHOD HbQtObjectHandler:_destroy()

//   ::__pSlots := NIL
//   ::__pEvents := NIL

   RETURN NIL

/*----------------------------------------------------------------------*/

FUNCTION hbqt_promotWidget( oWidget, cWidgetTo )
   LOCAL oObj := Eval( &( "{|| HB_" + cWidgetTo + "() }" ) )

   oObj:pPtr := oWidget:pPtr

   RETURN oObj

/*----------------------------------------------------------------------*/
