/*
 * $Id: wvgwnd.prg 14688 2010-06-04 13:32:23Z vszakats $
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
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                  Xbase++ Compatible xbpWindow Class
 *
 *                 Pritpal Bedi  <pritpal@vouchcac.com>
 *                              08Nov2008
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
 * To Switch Over from ASCALLBACK() to SET/GET_Prop() calls
 *
#if 0
   #define __BYASCALLBACK__
#else
   #define __BYSETPROP__
#endif

#ifndef __DBG_PARTS__
   #xtranslate hb_traceLog( [<x,...>] ) =>
#endif

/*----------------------------------------------------------------------*/

CLASS WvgWindow  INHERIT  WvgPartHandler

   /*  CONFIGURATION */
   DATA     animate                               INIT  .F.
   DATA     clipChildren                          INIT  .F.
   DATA     clipParent                            INIT  .F.
   DATA     clipSiblings                          INIT  .T.
   DATA     group                                 INIT  0    /* XBP_NO_GROUP */
   DATA     sizeRedraw                            INIT  .F.
   DATA     tabStop                               INIT  .F.
   DATA     visible                               INIT  .T.

   /*  RUNTIME DATA */
   DATA     dropZone                              INIT  .F.
   DATA     helpLink
   DATA     tooltipText                           INIT  ""

   DATA     clr_FG
   DATA     clr_BG
   DATA     fnt_COMMPOUNDNAME
   DATA     fnt_hFont

   /*  CALLBACK SLOTS */
   DATA     sl_enter
   DATA     sl_leave
   DATA     sl_lbClick
   DATA     sl_lbDblClick
   DATA     sl_lbDown
   DATA     sl_lbUp
   DATA     sl_mbClick
   DATA     sl_mbDblClick
   DATA     sl_mbDown
   DATA     sl_mbUp
   DATA     sl_motion
   DATA     sl_rbClick
   DATA     sl_rbDblClick
   DATA     sl_rbDown
   DATA     sl_rbUp
   DATA     sl_wheel

   DATA     sl_helpRequest
   DATA     sl_keyboard
   DATA     sl_killInputFocus
   DATA     sl_move
   DATA     sl_paint
   DATA     sl_quit
   DATA     sl_resize
   DATA     sl_setInputFocus
   DATA     sl_dragEnter
   DATA     sl_dragMotion
   DATA     sl_dragLeave
   DATA     sl_dragDrop

   DATA     sl_close
   DATA     sl_setDisplayFocus
   DATA     sl_killDisplayFocus

   DATA     hBrushBG
   DATA     is_hidden                             INIT   .F.
   DATA     is_enabled                            INIT   .T.
   DATA     title                                 INIT   " "
   DATA     icon                                  INIT   0
   DATA     closable                              INIT   .T.
   DATA     resizable                             INIT   .t.
   DATA     resizeMode                            INIT   0
   DATA     style                                 INIT   WS_OVERLAPPEDWINDOW
   DATA     exStyle                               INIT   0
   DATA     lModal                                INIT   .f.
   DATA     pGTp
   DATA     pGT
   DATA     objType                               INIT   objTypeNone
   DATA     className                             INIT   ""

   DATA     hWnd
   DATA     pWnd
   DATA     aPos                                  INIT   { 0,0 }
   DATA     aSize                                 INIT   { 0,0 }
   DATA     aPresParams                           INIT   {}
   DATA     lHasInputFocus                        INIT   .F.
   DATA     nFrameState                           INIT   0       /* normal */

   DATA     maxCol                                INIT   79
   DATA     maxRow                                INIT   24
   DATA     mouseMode                             INIT   1

   DATA     nID                                   INIT   0
   DATA     nControlID                            INIT   5000
   DATA     nOldProc                              INIT   0

   DATA     oMenu

   METHOD   init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   destroy()
   METHOD   SetWindowProcCallback()

   METHOD   captureMouse()
   METHOD   currentPos()
   METHOD   currentSize()
   METHOD   disable()
   METHOD   enable()
   METHOD   getHWND()
   METHOD   getModalState()
   METHOD   hasInputFocus()
   METHOD   hide()
   METHOD   invalidateRect( aRect )
   METHOD   lockPS()
   METHOD   lockUpdate()
   METHOD   isDerivedFrom( cClassORoObject )
   METHOD   setColorBG( nRGB )
   METHOD   setModalState()
   METHOD   setPointer()
   METHOD   setTrackPointer()
   METHOD   setPos( aPos, lPaint )
   METHOD   setPosAndSize( aPos, aSize, lPaint )
   METHOD   setSize( aSize, lPaint )
   METHOD   setFont()
   METHOD   setFontCompoundName( xFont )
   METHOD   setPresParam()
   METHOD   show()
   METHOD   toBack()
   METHOD   toFront()
   METHOD   unlockPS()
   METHOD   winDevice()

   METHOD   Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   setFocus()
   METHOD   sendMessage( nMessage, nlParam, nwParam )
   METHOD   findObjectByHandle( hWnd )
   METHOD   createControl()
   METHOD   ControlWndProc( hWnd, nMessage, nwParam, nlParam )

   METHOD   getControlID()                        INLINE ++::nControlID
   METHOD   HandleEvent()                         INLINE ( 1 )
   METHOD   isEnabled()                           INLINE ::is_enabled
   METHOD   isVisible()                           INLINE !( ::is_hidden )
   METHOD   setColorFG( nRGB )                    INLINE ::clr_FG := nRGB, ::invalidateRect()

   METHOD   enter( xParam )                       SETGET
   METHOD   leave( xParam )                       SETGET
   METHOD   lbClick( xParam )                     SETGET
   METHOD   lbDblClick( xParam )                  SETGET
   METHOD   lbDown( xParam )                      SETGET
   METHOD   lbUp( xParam )                        SETGET
   METHOD   mbClick( xParam )                     SETGET
   METHOD   mbDblClick( xParam )                  SETGET
   METHOD   mbDown( xParam )                      SETGET
   METHOD   mbUp( xParam )                        SETGET
   METHOD   motion( xParam )                      SETGET
   METHOD   rbClick( xParam )                     SETGET
   METHOD   rbDblClick( xParam )                  SETGET
   METHOD   rbDown( xParam )                      SETGET
   METHOD   rbUp( xParam )                        SETGET
   METHOD   wheel( xParam )                       SETGET
   METHOD   close( xParam )                       SETGET
   METHOD   helpRequest( xParam )                 SETGET
   METHOD   keyboard( xParam )                    SETGET
   METHOD   killDisplayFocus( xParam )            SETGET
   METHOD   killInputFocus( xParam )              SETGET
   METHOD   move( xParam )                        SETGET
   METHOD   paint( xParam )                       SETGET
   METHOD   quit( xParam, xParam1 )               SETGET
   METHOD   resize( xParam, xParam1 )             SETGET
   METHOD   setDisplayFocus( xParam )             SETGET
   METHOD   setInputFocus( xParam )               SETGET
   METHOD   dragEnter( xParam, xParam1 )          SETGET
   METHOD   dragMotion( xParam )                  SETGET
   METHOD   dragLeave( xParam )                   SETGET
   METHOD   dragDrop( xParam, xParam1 )           SETGET

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD WvgWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::aSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible

   ::WvgPartHandler:init( oParent, oOwner )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::aSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible

   ::WvgPartHandler:create( oParent, oOwner )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::sSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible


   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:destroy()
   #if 0
   hb_traceLog( "          %s:destroy() WvgWindow()", __objGetClsName( self ) )
   #endif

   IF Len( ::aChildren ) > 0
      aeval( ::aChildren, {|o| o:destroy() } )
      ::aChildren := {}
   ENDIF

   WVG_ReleaseWindowProcBlock( ::pWnd )

   IF WVG_IsWindow( ::hWnd )
      WVG_DestroyWindow( ::hWnd )
   ENDIF

   IF ::hBrushBG <> NIL
      WVG_DeleteObject( ::hBrushBG )
   ENDIF

   ::hWnd                   := NIL
   ::pWnd                   := NIL
   ::aPos                   := NIL
   ::aSize                  := NIL
   ::aPresParams            := NIL
   ::lHasInputFocus         := NIL
   ::nFrameState            := NIL
   ::maxCol                 := NIL
   ::maxRow                 := NIL
   ::mouseMode              := NIL
   ::nID                    := NIL
   ::nControlID             := NIL
   ::nOldProc               := NIL
   ::oMenu                  := NIL
   ::animate                := NIL
   ::clipChildren           := NIL
   ::clipParent             := NIL
   ::clipSiblings           := NIL
   ::group                  := NIL
   ::sizeRedraw             := NIL
   ::tabStop                := NIL
   ::visible                := NIL
   ::dropZone               := NIL
   ::helpLink               := NIL
   ::tooltipText            := NIL
   ::clr_FG                 := NIL
   ::clr_BG                 := NIL
   ::fnt_COMMPOUNDNAME      := NIL
   ::fnt_hFont              := NIL
   ::sl_enter               := NIL
   ::sl_leave               := NIL
   ::sl_lbClick             := NIL
   ::sl_lbDblClick          := NIL
   ::sl_lbDown              := NIL
   ::sl_lbUp                := NIL
   ::sl_mbClick             := NIL
   ::sl_mbDblClick          := NIL
   ::sl_mbDown              := NIL
   ::sl_mbUp                := NIL
   ::sl_motion              := NIL
   ::sl_rbClick             := NIL
   ::sl_rbDblClick          := NIL
   ::sl_rbDown              := NIL
   ::sl_rbUp                := NIL
   ::sl_wheel               := NIL
   ::sl_helpRequest         := NIL
   ::sl_keyboard            := NIL
   ::sl_killInputFocus      := NIL
   ::sl_move                := NIL
   ::sl_paint               := NIL
   ::sl_quit                := NIL
   ::sl_resize              := NIL
   ::sl_setInputFocus       := NIL
   ::sl_dragEnter           := NIL
   ::sl_dragMotion          := NIL
   ::sl_dragLeave           := NIL
   ::sl_dragDrop            := NIL
   ::sl_close               := NIL
   ::sl_setDisplayFocus     := NIL
   ::sl_killDisplayFocus    := NIL

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD WvgWindow:SetWindowProcCallback()

   ::nOldProc := WVG_SetWindowProcBlock( ::pWnd, {|h,m,w,l| ::ControlWndProc( h,m,w,l ) } )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:captureMouse()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:disable()

   IF WVG_EnableWindow( ::hWnd, .f. )
      ::is_enabled := .f.
      RETURN .t.
   ENDIF

   RETURN .f.

/*----------------------------------------------------------------------*/

METHOD WvgWindow:enable()

   IF WVG_EnableWindow( ::hWnd, .t. )
      ::is_enabled := .t.
      RETURN .t.
   ENDIF

   RETURN .f.

/*----------------------------------------------------------------------*/

METHOD WvgWindow:hide()

   IF WVG_IsWindow( ::hWnd )
      WVG_ShowWindow( ::hWnd, SW_HIDE )
      ::is_hidden := .t.
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:invalidateRect( aRect )

   RETURN WVG_InvalidateRect( ::hWnd, aRect )

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lockPS()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lockUpdate()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setColorBG( nRGB )
   LOCAL hBrush

   IF hb_isNumeric( nRGB )
      hBrush := WVG_CreateBrush( BS_SOLID, nRGB, 0 )
      IF hBrush <> 0
         ::clr_BG := nRGB
         ::hBrushBG := hBrush

         IF ::className == "WVGDIALOG"
            Wvg_SetCurrentBrush( ::hWnd, ::hBrushBG )
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setModalState()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setPointer()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setTrackPointer()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setPos( aPos, lPaint )

   IF hb_isArray( aPos )
      DEFAULT lPaint TO .T.

      SWITCH ::objType

      CASE objTypeCrt
         exit

      OTHERWISE
         WVG_SetWindowPosition( ::hWnd, aPos[ 1 ], aPos[ 2 ], lPaint )
         EXIT

      END
   ENDIF


   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setPosAndSize( aPos, aSize, lPaint )

   IF hb_isArray( aPos ) .and. hb_isArray( aSize )
      DEFAULT lPaint TO .T.

      SWITCH ::objType

      CASE objTypeCrt
         exit

      OTHERWISE
         /*WVG_MoveWindow( ::hWnd, aPos[ 1 ], aPos[ 2 ], aSize[ 1 ], aSize[ 2 ], lPaint ) */
         WVG_SetWindowPosAndSize( ::hWnd, aPos[ 1 ], aPos[ 2 ], aSize[ 1 ], aSize[ 2 ], lPaint )
         EXIT

      END
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setSize( aSize, lPaint )

   IF hb_isArray( aSize )
      DEFAULT lPaint TO .T.

      SWITCH ::objType

      CASE objTypeDialog
         /*WVG_MoveWindow( ::hWnd, 0, 0, aSize[ 1 ], aSize[ 2 ], lPaint ) */
         WVG_SetWindowSize( ::hWnd, aSize[ 1 ], aSize[ 2 ], lPaint )
         EXIT

      END
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:isDerivedFrom( cClassORoObject )
   LOCAL lTrue := .f.
   LOCAL cCls := __ObjGetClsName( self )

   /* Compares without Xbp or Wvg prefixes  */

   IF hb_isChar( cClassORoObject )
      IF upper( substr( cClassORoObject,4 ) ) == upper( substr( cCls,4 ) )
         lTrue := .t.
      ENDIF

   ELSEIF hb_isObject( cClassORoObject )
      IF upper( substr( cClassORoObject:className,4 ) ) == upper( substr( cCls,4 ) )
         lTrue := .t.
      ENDIF
   ENDIF

   RETURN lTrue

/*----------------------------------------------------------------------*/

METHOD WvgWindow:show()

   WVG_ShowWindow( ::hWnd, SW_NORMAL )
   ::is_hidden      := .f.
   ::lHasInputFocus := .t.

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:toBack()

   RETURN WVG_SetWindowPosToBack( ::hWnd )

/*----------------------------------------------------------------------*/

METHOD WvgWindow:toFront()

   /*RETURN WVG_SetForeGroundWindow( ::hWnd ) */
   RETURN WVG_SetWindowPosToTop( ::hWnd )

/*----------------------------------------------------------------------*/

METHOD WvgWindow:unlockPS()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:winDevice()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setFont()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setFontCompoundName( xFont )
   LOCAL cOldFont, s, n, nPoint, cFont, cAttr, cFace
   LOCAL aAttr := { "normal","italic","bold" }

   cOldFont := ::fnt_COMMPOUNDNAME

   IF hb_isNumeric( cFont )

   ELSE
      IF !empty( xFont )
         cFont := xFont
         s := lower( cFont )
         n := ascan( aAttr, {|e| at( e, cFont ) > 0 } )
         IF n > 0
            cAttr := aAttr[ n ]
            n := at( cAttr, s )
            cFont := substr( cFont,1,n-1 )
         ELSE
            cAttr := "normal"
         ENDIF

         IF ( n := at( ".", cFont ) ) > 0
            nPoint := val( substr( cFont,1,n-1 ) )
            cFont  := substr( cFont,n+1 )
         ELSE
            nPoint := 0
         ENDIF

         cFace := alltrim( cFont )

         HB_SYMBOL_UNUSED( cFace )
         HB_SYMBOL_UNUSED( cAttr )
         HB_SYMBOL_UNUSED( nPoint )
      ENDIF
   ENDIF

   RETURN cOldFont

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setPresParam()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:currentPos()
   LOCAL aRect

   aRect := WVG_GetWindowRect( ::hWnd )

   RETURN { aRect[ 1 ], aRect[ 2 ] }

/*----------------------------------------------------------------------*/

METHOD WvgWindow:currentSize()
   LOCAL aRect

   aRect := WVG_GetClientRect( ::hWnd )

   RETURN { aRect[ 3 ] - aRect[ 1 ], aRect[ 4 ] - aRect[ 2 ] }

/*----------------------------------------------------------------------*/

METHOD WvgWindow:getHWND()

   RETURN ::hWnd

/*----------------------------------------------------------------------*/

METHOD WvgWindow:getModalState()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:hasInputFocus()

   RETURN Self

/*----------------------------------------------------------------------*/
 *                           Callback Methods
/*----------------------------------------------------------------------*/

METHOD WvgWindow:enter( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_enter )
      eval( ::sl_enter, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_enter := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:leave( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_leave )
      eval( ::sl_leave, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_leave := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lbClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbClick )
      eval( ::sl_lbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lbDblClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbDblClick )
      eval( ::sl_lbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lbDown( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbDown )
      eval( ::sl_lbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:lbUp( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_lbUp )
      eval( ::sl_lbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_lbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:mbClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbClick )
      eval( ::sl_mbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:mbDblClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbDblClick )
      eval( ::sl_mbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:mbDown( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbDown )
      eval( ::sl_mbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:mbUp( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_mbUp )
      eval( ::sl_mbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_mbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:motion( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_motion )
      eval( ::sl_motion, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_motion := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:rbClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbClick )
      eval( ::sl_rbClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:rbDblClick( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbDblClick )
      eval( ::sl_rbDblClick, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbDblClick := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:rbDown( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbDown )
      eval( ::sl_rbDown, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbDown := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:rbUp( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_rbUp )
      eval( ::sl_rbUp, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_rbUp := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:wheel( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_wheel )
      eval( ::sl_wheel, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_wheel := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/
 *                           Other Messages
/*----------------------------------------------------------------------*/

METHOD WvgWindow:close( xParam )
   if ::objType == objTypeCrt
      if hb_isNil( xParam ) .and. hb_isBlock( ::sl_close )
         eval( ::sl_close, NIL, NIL, Self )
         RETURN Self
      endif

      if hb_isBlock( xParam ) .or. hb_isNil( xParam )
         ::sl_close := xParam
         RETURN NIL
      endif
   endif
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:helpRequest( xParam )

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_helpRequest )
      eval( ::sl_helpRequest, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_helpRequest := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:keyboard( xParam )

   if hb_isNumeric( xParam ) .and. hb_isBlock( ::sl_keyboard )
      eval( ::sl_keyboard, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_keyboard := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:killDisplayFocus( xParam )
   if ::objType == objTypeCrt
      if hb_isNil( xParam ) .and. hb_isBlock( ::sl_killDisplayFocus )
         eval( ::sl_killDisplayFocus, NIL, NIL, Self )
         RETURN Self
      endif

      if hb_isBlock( xParam ) .or. hb_isNil( xParam )
         ::sl_killDisplayFocus := xParam
         RETURN NIL
      endif
   endif
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:killInputFocus( xParam )

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_killInputFocus )
      eval( ::sl_killInputFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_killInputFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:move( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_move )
      eval( ::sl_move, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_move := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:paint( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_paint )
      eval( ::sl_paint, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_paint := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:quit( xParam, xParam1 )

   if hb_isNumeric( xParam ) .and. hb_isBlock( ::sl_quit )
      eval( ::sl_quit, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_quit := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:resize( xParam, xParam1 )

   if hb_isArray( xParam ) .and. hb_isArray( xParam1 ) .and. hb_isBlock( ::sl_resize )
      eval( ::sl_resize, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) /*.or. hb_isNil( xParam )*/
      ::sl_resize := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setDisplayFocus( xParam )

   if ::objType == objTypeCrt
      if hb_isNil( xParam ) .and. hb_isBlock( ::setDisplayFocus )
         eval( ::setDisplayFocus, NIL, NIL, Self )
         RETURN Self
      endif

      if hb_isBlock( xParam ) .or. hb_isNil( xParam )
         ::setDisplayFocus := xParam
         RETURN NIL
      endif
   endif
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setInputFocus( xParam )

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_setInputFocus )
      eval( ::sl_setInputFocus, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_setInputFocus := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:dragEnter( xParam, xParam1 )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragEnter )
      eval( ::sl_dragEnter, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragEnter := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:dragMotion( xParam )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragMotion )
      eval( ::sl_dragMotion, xParam, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragMotion := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:dragLeave( xParam )

   if hb_isNil( xParam ) .and. hb_isBlock( ::sl_dragLeave )
      eval( ::sl_dragLeave, NIL, NIL, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragLeave := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:dragDrop( xParam, xParam1 )

   if hb_isArray( xParam ) .and. hb_isBlock( ::sl_dragDrop )
      eval( ::sl_dragDrop, xParam, xParam1, Self )
      RETURN Self
   endif

   if hb_isBlock( xParam ) .or. hb_isNil( xParam )
      ::sl_dragDrop := xParam
      RETURN NIL
   endif

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::aSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:setFocus()

   ::sendMessage( WM_ACTIVATE, 1, 0 )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD WvgWindow:sendMessage( nMessage, nlParam, nwParam )

   RETURN WVG_SendMessage( ::hWnd, nMessage, nlParam, nwParam )

/*----------------------------------------------------------------------*/

METHOD WvgWindow:findObjectByHandle( hWnd )
   LOCAL nObj

   IF len( ::aChildren ) > 0
      IF ( nObj := ascan( ::aChildren, {|o| o:hWnd == hWnd } ) ) > 0
         RETURN ::aChildren[ nObj ]
      ENDIF
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD WvgWindow:createControl()
   LOCAL hWnd

   ::nID := ::oParent:GetControlId()

   hWnd := WVG_CreateWindowEx( ::exStyle, ;
                               ::className, ;
                               "", ;                              /* window name */
                               ::style, ;
                               ::aPos[ 1 ], ::aPos[ 2 ],;
                               ::aSize[ 1 ], ::aSize[ 2 ],;
                               ::oParent:hWnd,;
                               ::nID,;                            /* hMenu       */
                               NIL,;                              /* hInstance   */
                               NIL )                              /* lParam      */


   IF ( hWnd <> 0 )
      ::hWnd := hWnd
      ::pWnd := WIN_N2P( hWnd )
      ::sendMessage( WM_SETFONT, WVG_GetStockObject( DEFAULT_GUI_FONT ), 1 )
   ENDIF

   RETURN Self
/*----------------------------------------------------------------------*/

METHOD WvgWindow:ControlWndProc( hWnd, nMessage, nwParam, nlParam )
   LOCAL nCtrlID, nNotifctn, hWndCtrl, nObj, aMenuItem, oObj, nReturn

   #if 1
   hb_traceLog( "%s:wndProc( %i  %i  %i  %i )", __ObjGetClsName( self ), hWnd, nMessage, nwParam, nlParam )
   #endif

   SWITCH nMessage

   CASE WM_ERASEBKGND
      IF ::objType == objTypeDA .and. !empty( ::hBrushBG )
         ::handleEvent( HB_GTE_CTLCOLOR, { nwParam, nlParam } )
      ENDIF
      EXIT

   CASE WM_COMMAND
      nCtrlID   := WVG_LOWORD( nwParam )
      nNotifctn := WVG_HIWORD( nwParam )
      hWndCtrl  := nlParam

      IF hWndCtrl == 0                            /* It is menu */
         IF hb_isObject( ::oMenu )
            IF !empty( aMenuItem := ::oMenu:FindMenuItemById( nCtrlID ) )
               IF hb_isBlock( aMenuItem[ 2 ] )
                  Eval( aMenuItem[ 2 ], aMenuItem[ 1 ], NIL, aMenuItem[ 4 ] )

               ELSEIF hb_isBlock( aMenuItem[ 3 ] )
                  Eval( aMenuItem[ 3 ], aMenuItem[ 1 ], NIL, aMenuItem[ 4 ] )

               ENDIF
            ENDIF
         ENDIF
         RETURN 0
      ELSE
         IF ( nObj := ascan( ::aChildren, {|o| o:nID == nCtrlID } ) ) > 0
            nReturn := ::aChildren[ nObj ]:handleEvent( HB_GTE_COMMAND, { nNotifctn, nCtrlID, hWndCtrl } )
            IF hb_isNumeric( nReturn ) .and. nReturn == 0
               RETURN 0
            ENDIF
         ENDIF
      ENDIF
      EXIT

   CASE WM_NOTIFY
      IF ( nObj := ascan( ::aChildren, {| o | o:nID == nwParam } ) ) > 0
         nReturn := ::aChildren[ nObj ]:handleEvent( HB_GTE_NOTIFY, { nwParam, nlParam } )
         IF hb_isNumeric( nReturn ) .and. nReturn == EVENT_HANDELLED
            RETURN EVENT_HANDELLED
         ENDIF
      ENDIF
      EXIT

   CASE WM_CTLCOLORLISTBOX
   CASE WM_CTLCOLORMSGBOX
   CASE WM_CTLCOLOREDIT
   CASE WM_CTLCOLORBTN
   CASE WM_CTLCOLORDLG
   CASE WM_CTLCOLORSCROLLBAR
   CASE WM_CTLCOLORSTATIC

      oObj := ::findObjectByHandle( nlParam )
      IF hb_isObject( oObj )
         nReturn := oObj:handleEvent( HB_GTE_CTLCOLOR, { nwParam, nlParam } )

         IF nReturn == 1
            RETURN WVG_CallWindowProc( ::nOldProc, hWnd, nMessage, nwParam, nlParam )
         ELSE
            RETURN nReturn
         ENDIF
      ENDIF
      EXIT

   CASE WM_HSCROLL
      ::handleEvent( HB_GTE_HSCROLL, { WVG_LOWORD( nwParam ), WVG_HIWORD( nwParam ), nlParam } )
      RETURN 0

   CASE WM_VSCROLL
      nReturn := ::handleEvent( HB_GTE_VSCROLL, { WVG_LOWORD( nwParam ), WVG_HIWORD( nwParam ), nlParam } )
      IF nReturn == EVENT_HANDELLED
         RETURN 0
      ENDIF
      EXIT

   CASE WM_CAPTURECHANGED
      EXIT
#if 0
   CASE WM_MOUSEMOVE
      IF ::objType == objTypeScrollBar
         IF !( ::lTracking )
            ::lTracking := Wvg_BeginMouseTracking( ::hWnd )
         ENDIF
      ENDIF
      EXIT

   CASE WM_MOUSEHOVER
      IF ::objType == objTypeScrollBar
         IF ::oParent:objType == objTypeCrt
            WAPI_SetFocus( ::oParent:pWnd )
         ENDIF
         RETURN 0
      ENDIF
      EXIT

   CASE WM_MOUSELEAVE
      IF ::objType == objTypeScrollBar
         ::lTracking := .f.
         IF ::oParent:objType == objTypeCrt
            WAPI_SetFocus( ::oParent:pWnd )
         ENDIF
      ENDIF
      EXIT
#endif
   END

   RETURN WVG_CallWindowProc( ::nOldProc, hWnd, nMessage, nwParam, nlParam )

/*----------------------------------------------------------------------*/
