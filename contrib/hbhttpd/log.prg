/*
 * $Id: log.prg 15881 2010-11-24 14:43:43Z vszakats $
 */

/*
 * Harbour Project source code:
 * Simple logger class
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
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

#include "fileio.ch"

CREATE CLASS UHttpdLog

   METHOD New( cFileName )
   METHOD Add( cMsg )
   METHOD Close()
   METHOD IsOpen()

   PROTECTED:

   VAR cFileName
   VAR fhnd      INIT F_ERROR

ENDCLASS

METHOD New( cFileName ) CLASS UHttpdLog
   LOCAL cExt

   IF hb_isString( cFileName )

      IF Set( _SET_DEFEXTENSIONS )
         hb_FNameSplit( cFileName, NIL, NIL, @cExt )
         IF Empty( cExt )
            cFileName += ".log"
         ENDIF
      ENDIF

      ::cFileName := cFileName
   ENDIF

   RETURN Self

METHOD IsOpen() CLASS UHttpdLog
   RETURN ::fhnd != F_ERROR

METHOD Add( cMsg ) CLASS UHttpdLog

   IF ! hb_isString( cMsg )
      RETURN .F.
   ENDIF

   IF ::fhnd == F_ERROR .AND. ! Empty( ::cFileName )
      ::fhnd := hb_FCreate( ::cFileName, FC_NORMAL, FO_WRITE + FO_DENYNONE )
   ENDIF

   RETURN ::fhnd != F_ERROR .AND. FWrite( ::fhnd, cMsg ) == Len( cMsg )

METHOD Close() CLASS UHttpdLog
   LOCAL lRetVal

   IF ::fhnd != F_ERROR
      lRetVal := FClose( ::fhnd )
      ::fhnd := F_ERROR
   ELSE
      lRetVal := .F.
   ENDIF

   RETURN lRetVal
