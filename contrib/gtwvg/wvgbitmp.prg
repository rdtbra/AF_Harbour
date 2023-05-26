/*
 * $Id: wvgbitmp.prg 14688 2010-06-04 13:32:23Z vszakats $
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
 *                   Xbase++ xbpBitmap compatible Class
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               06Dec2008
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

CLASS WvgBitmap

   DATA     bits                                  INIT 0        READONLY
   DATA     bufferOffset                          INIT 0        READONLY
   DATA     planes                                INIT 0        READONLY
   DATA     transparentClr                        INIT 0
   DATA     xSize                                 INIT 0        READONLY
   DATA     ySize                                 INIT 0        READONLY

   DATA     hBitmap
   DATA     hDCcompat
   DATA     lDCToDestroy                          INIT .f.

   METHOD   new()
   METHOD   create( oPScompat )
   METHOD   configure()                           VIRTUAL
   METHOD   destroy()

   METHOD   draw()                                VIRTUAL
   METHOD   getColorTable()                       VIRTUAL
   METHOD   getDefaultBGColor()                   VIRTUAL
   METHOD   load()                                VIRTUAL
   METHOD   loadFile()                            VIRTUAL
   METHOD   make()                                VIRTUAL
   METHOD   presSpace()                           VIRTUAL
   METHOD   saveFile()                            VIRTUAL
   METHOD   setBuffer()                           VIRTUAL
   METHOD   getPicture()                          VIRTUAL
   METHOD   setPicture()                          VIRTUAL

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD new() CLASS WvgBitmap

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD create( oPScompat ) CLASS WvgBitmap

   IF oPScompat == NIL
      ::hDCComp := WVG_GetDC()
      ::lDCToDestroy := .t.
   ELSE
      ::hDCComp := oPScompat:hDC
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD destroy() CLASS WvgBitmap

   IF ::hBitmap <> nil
      WVG_DeleteObject( ::hBitmap )
   ENDIF
   IF ::lDCtoDestroy
      WVG_ReleaseDC( ::hDCcompat )
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/
