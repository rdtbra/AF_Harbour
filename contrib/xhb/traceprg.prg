/*
 * $Id: traceprg.prg 16744 2011-05-09 18:07:27Z vszakats $
 */

/*
 * xHarbour Project source code:
 * PRG Tracing System
 *
 * Copyright 2001 Ron Pinkas <ron@@ronpinkas.com>
 * www - http://www.xharbour.org
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
 * As a special exception, xHarbour license gives permission for
 * additional uses of the text contained in its release of xHarbour.
 *
 * The exception is that, if you link the xHarbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the xHarbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released with this xHarbour
 * explicit exception.  If you add/copy code from other sources,
 * as the General Public License permits, the above exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for xHarbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "set.ch"
#include "fileio.ch"

#define HB_SET_TRACESTACK_NONE    0
#define HB_SET_TRACESTACK_CURRENT 1
#define HB_SET_TRACESTACK_ALL     2

#xtranslate Write( <cString> ) => FWrite( FileHandle, <cString> ) //;HB_OutDebug( <cString> )

STATIC s_lSET_TRACE      := .T.
STATIC s_cSET_TRACEFILE  := "trace.log"
STATIC s_nSET_TRACESTACK := HB_SET_TRACESTACK_ALL

FUNCTION xhb_setTrace( xTrace )
   LOCAL lTrace := s_lSET_TRACE

   IF HB_ISLOGICAL( xTrace )
      s_lSET_TRACE := xTrace
   ELSEIF HB_ISSTRING( xTrace )
      IF Upper( xTrace ) == "ON"
         s_lSET_TRACE := .T.
      ELSEIF Upper( xTrace ) == "OFF"
         s_lSET_TRACE := .F.
      ENDIF
   ENDIF

   RETURN lTrace

FUNCTION xhb_setTraceFile( xFile, lAppend )
   LOCAL cTraceFile := s_cSET_TRACEFILE

   IF HB_ISSTRING( xFile )
      s_cSET_TRACEFILE := xFile
      IF !HB_ISLOGICAL( lAppend ) .OR. !lAppend
         FClose( FCreate( s_cSET_TRACEFILE ) )
      ENDIF
   ENDIF

   RETURN cTraceFile

FUNCTION xhb_setTraceStack( xLevel )
   LOCAL nTraceLevel := s_nSET_TRACESTACK

   IF HB_ISSTRING( xLevel )
      IF Upper( xLevel ) == "NONE"
         s_nSET_TRACESTACK := HB_SET_TRACESTACK_NONE
      ELSEIF Upper( xLevel ) == "CURRENT"
         s_nSET_TRACESTACK := HB_SET_TRACESTACK_CURRENT
      ELSEIF Upper( xLevel ) == "ALL"
         s_nSET_TRACESTACK := HB_SET_TRACESTACK_ALL
      ENDIF
   ELSEIF HB_ISNUMERIC( xLevel )
      IF xLevel >= 0
         s_nSET_TRACESTACK := xLevel
      ENDIF
   ENDIF

   RETURN nTraceLevel

//--------------------------------------------------------------//

FUNCTION TraceLog( ... )

   // Using PRIVATE instead of LOCALs so TraceLog() is DIVERT friendly.
   LOCAL cFile, FileHandle, nLevel, ProcName, xParam

#ifdef __XHARBOUR__
   IF ! SET( _SET_TRACE )
      RETURN .T.
   ENDIF

   cFile := SET( _SET_TRACEFILE )
   nLevel := SET( _SET_TRACESTACK )
#else
   IF !s_lSET_TRACE
      RETURN .T.
   ENDIF

   cFile := s_cSET_TRACEFILE
   nLevel := s_nSET_TRACESTACK
#endif

   /* hb_FileExists() and FOpen()/FCreate() make different assumptions rgdg path,
      so we have to make sure cFile contains path to avoid ambiguity */
   cFile := cWithPath( cFile )

   IF hb_FileExists( cFile )
      FileHandle := FOpen( cFile, FO_WRITE )
   ELSE
      FileHandle := FCreate( cFile )
   ENDIF

   FSeek( FileHandle, 0, FS_END )

   IF nLevel > 0
      Write( '[' + ProcFile(1) + "->" + ProcName( 1 ) + '] (' + LTrim( Str( Procline(1) ) ) + ')' )
   ENDIF

   IF nLevel > 1 .AND. ! ( ProcName( 2 ) == '' )
      Write( ' Called from: '  + hb_eol() )
      nLevel := 1
      DO WHILE ! ( ( ProcName := ProcName( ++nLevel ) ) == '' )
         Write( space(30) + ProcFile( nLevel ) + "->" + ProcName + '(' + LTrim( Str( Procline( nLevel ) ) ) + ')' + hb_eol() )
      ENDDO
   ELSE
      Write( hb_eol() )
   ENDIF

   FOR EACH xParam IN HB_aParams()
      Write( 'Type: ' + ValType( xParam ) + ' >>>' + hb_CStr( xParam ) + '<<<' + hb_eol() )
   NEXT

   Write( hb_eol() )

   FClose( FileHandle )

   RETURN .T.

//--------------------------------------------------------------//

STATIC FUNCTION cWithPath( cFilename )
/* Ensure cFilename contains path. If it doesn't, add current directory to the front of it */
   LOCAL cPath
   hb_fnamesplit( cFilename, @cPath )
   RETURN iif( Empty( cPath ), "." + hb_ps(), "" ) + cFilename
