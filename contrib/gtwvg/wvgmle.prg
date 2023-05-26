/*
 * $Id: wvgmle.prg 16746 2011-05-09 20:26:14Z vszakats $
 */

/*
 * Harbour Project source code:
 * Source file for the Wvg*Classes
 *
 * Copyright 2008 Pritpal Bedi <pritpal@vouchcac.com>
 * http://harbour-project.org
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
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                    Xbase++ xbpMLE compatible Class
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               07Dec2008
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"

#include "hbgtwvg.ch"
#include "wvtwin.ch"
#include "wvgparts.ch"

/*----------------------------------------------------------------------*/

#ifndef __DBG_PARTS__
#xtranslate hb_traceLog( [<x,...>] ) =>
#endif

/*----------------------------------------------------------------------*/

CLASS WvgMLE INHERIT WvgWindow, DataRef

   DATA     border                                INIT    .T.
   DATA     editable                              INIT    .T.
   DATA     horizScroll                           INIT    .T.
   DATA     vertScroll                            INIT    .T.
   DATA     wordWrap                              INIT    .T.
   DATA     ignoreTab                             INIT    .F.

   DATA     bufferLength                          INIT    32000
   DATA     changed                               INIT    .F.

   METHOD   new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )  VIRTUAL
   METHOD   destroy()
   METHOD   handleEvent( nMessage, aNM )

   METHOD   clear()                               VIRTUAL
   METHOD   copyMarked()                          VIRTUAL
   METHOD   cutMarked()                           VIRTUAL
   METHOD   deleteMarked()                        VIRTUAL
   METHOD   delete()                              VIRTUAL
   METHOD   pasteMarked()                         VIRTUAL
   METHOD   queryFirstChar()                      VIRTUAL
   METHOD   queryMarked()                         VIRTUAL
   METHOD   setFirstChar()                        VIRTUAL
   METHOD   setMarked()                           VIRTUAL
   METHOD   insert()                              VIRTUAL
   METHOD   charFromLine()                        VIRTUAL
   METHOD   lineFromChar()                        VIRTUAL
   METHOD   pos()                                 VIRTUAL

   DATA     sl_undo                               INIT    .T.
   ACCESS   undo                                  INLINE  iif( ::sl_undo, NIL, NIL )
   ASSIGN   undo( lUndo )                         INLINE  ::sl_undo := lUndo

   METHOD   setEditable()                         VIRTUAL
   METHOD   setWrap()                             VIRTUAL

   DATA     sl_hScroll
   ACCESS   hScroll                               INLINE  ::sl_hScroll
   ASSIGN   hScroll( bBlock )                     INLINE  ::sl_hScroll := bBlock

   DATA     sl_vScroll
   ACCESS   vScroll                               INLINE  ::sl_vScroll
   ASSIGN   vScroll( bBlock )                     INLINE  ::sl_vScroll := bBlock

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgMLE

   ::wvgWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::style       := WS_CHILD + ES_MULTILINE + ES_WANTRETURN
   ::exStyle     := WS_EX_CLIENTEDGE
   ::className   := "EDIT"
   ::objType     := objTypeMLE

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgMLE

   ::wvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   IF ::tabStop
      ::style += WS_TABSTOP
   ENDIF
   IF !::editable
      ::style += ES_READONLY
   ENDIF
   IF ::border
      ::style += WS_BORDER
   ENDIF
   IF !( ::wordWrap )
      IF ::horizScroll
         ::style += WS_HSCROLL
      ELSE
         ::style += ES_AUTOHSCROLL
      ENDIF
   ENDIF
   IF ::vertScroll
      ::style += WS_VSCROLL
   ELSE
      ::style += ES_AUTOVSCROLL
   ENDIF

   ::oParent:addChild( Self )

   ::createControl()

   ::SetWindowProcCallback()

   IF ::visible
      ::show()
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD handleEvent( nMessage, aNM ) CLASS WvgMLE

   hb_traceLog( "       %s:handleEvent( %i )", __objGetClsName( self ), nMessage )

   DO CASE
   CASE nMessage == HB_GTE_COMMAND
      DO CASE
      CASE aNM[ NMH_code ] == EN_CHANGE
         ::changed := .t.

      CASE aNM[ NMH_code ] == EN_UPDATE

      CASE aNM[ NMH_code ] == EN_MAXTEXT

      CASE aNM[ NMH_code ] == EN_KILLFOCUS
         IF hb_isBlock( ::sl_killInputFocus )
            eval( ::sl_killInputFocus, NIL, NIL, Self )
         ENDIF

      CASE aNM[ NMH_code ] == EN_SETFOCUS
         IF hb_isBlock( ::sl_setInputFocus )
            eval( ::sl_setInputFocus, NIL, NIL, Self )
         ENDIF

      CASE aNM[ NMH_code ] == EN_HSCROLL
         IF hb_isBlock( ::sl_hScroll )
            eval( ::sl_hScroll, NIL, NIL, Self )
         ENDIF

      CASE aNM[ NMH_code ] == EN_VSCROLL
         IF hb_isBlock( ::sl_vScroll )
            eval( ::sl_vScroll, NIL, NIL, Self )
         ENDIF

      ENDCASE

   CASE nMessage ==  HB_GTE_CTLCOLOR
      IF hb_isNumeric( ::clr_FG )
         WVG_SetTextColor( aNM[ 1 ], ::clr_FG )
      ENDIF
      IF hb_isNumeric( ::hBrushBG )
         WVG_SetBkMode( aNM[ 1 ], 1 )
         RETURN ::hBrushBG
      ELSE
         RETURN WVG_GetCurrentBrush( aNM[ 1 ] )
      ENDIF

   ENDCASE

   RETURN 0

/*----------------------------------------------------------------------*/

METHOD destroy() CLASS WvgMLE

   hb_traceLog( "          %s:destroy()", __objGetClsName( self ) )

   ::wvgWindow:destroy()

   RETURN NIL

/*----------------------------------------------------------------------*/
