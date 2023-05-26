/*
 * $Id: wvgdarea.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 * Source file for the Wvg*Classes
 *
 * Copyright 2009 Pritpal Bedi <pritpal@vouchcac.com>
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
 *                   Xbase++ WvgDialog's Helper Class
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               15Feb2009
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

CLASS WvgDrawingArea  INHERIT  WvgWindow

   DATA     caption                               INIT ""
   DATA     clipParent                            INIT .T.
   DATA     clipSiblings                          INIT .T.

   METHOD   new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   destroy()
   METHOD   handleEvent( nMessage, aNM )

   ENDCLASS
/*----------------------------------------------------------------------*/

METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgDrawingArea

   ::wvgWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::style       := WS_CHILD
   ::exStyle     := 0
   ::className   := "DrawingArea"
   ::objType     := objTypeDA
   ::visible     := .t.

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible ) CLASS WvgDrawingArea

   HB_SYMBOL_UNUSED( lVisible )

   ::wvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, .t. )

   ::oParent:addChild( SELF )

   Wvg_RegisterClass_ByName( ::className )

   ::createControl()

   ::SetWindowProcCallback()

   ::show()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD handleEvent( nMessage, aNM ) CLASS WvgDrawingArea
   LOCAL hDC

   hb_traceLog( "       %s:handleEvent( %i )", __ObjGetClsName( self ), nMessage )

   DO CASE

   CASE nMessage == HB_GTE_RESIZED
      IF hb_isBlock( ::sl_resize )
         eval( ::sl_resize, NIL, NIL, self )
      ENDIF
      aeval( ::aChildren, {|o| o:handleEvent( HB_GTE_RESIZED, { 0, 0, 0, 0, 0 } ) } )
      RETURN 0

   CASE nMessage == HB_GTE_CTLCOLOR
      hDC := aNM[ 1 ]

      IF hb_isNumeric( ::clr_FG )
         WVG_SetTextColor( hDC, ::clr_FG )
      ENDIF
      IF hb_isNumeric( ::hBrushBG )
         WVG_SetBkMode( hDC, 1 )

         Wvg_FillRect( hDC, { 0,0,::currentSize()[1],::currentSize()[1]}, ::hBrushBG )
         RETURN 0
      ENDIF

   ENDCASE

   RETURN 1

/*----------------------------------------------------------------------*/

METHOD destroy() CLASS WvgDrawingArea

   hb_traceLog( "          %s:destroy()", __objGetClsName( self ) )

   ::wvgWindow:destroy()

   RETURN NIL

/*----------------------------------------------------------------------*/
