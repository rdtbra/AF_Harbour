/*
 * $Id: testax.prg 14264 2010-04-02 07:41:59Z vszakats $
 */

#include "hbgtinfo.ch"
#include "hbclass.ch"
#include "hbwin.ch"

REQUEST HB_GT_WVT_DEFAULT

PROCEDURE Main()
   LOCAL oMSCAL

   WAIT "Make sure we are 'Active Window'"
   oMSCAL := HActiveX():Init( WAPI_GetActiveWindow(), "MSCAL.Calendar", 0, 0, 300, 300 )
   WAIT "Press any key to exit"

   HB_SYMBOL_UNUSED( oMSCAL )

   RETURN

CREATE CLASS HActiveX
   VAR oOLE
   VAR hWnd
   METHOD Init
   METHOD Event
   ERROR HANDLER OnError
   DESTRUCTOR Close
ENDCLASS

METHOD Init( hWnd, cProgId, nTop, nLeft, nWidth, nHeight, cID ) CLASS HActiveX
   LOCAL nStyle := WIN_WS_CHILD + WIN_WS_VISIBLE + WIN_WS_CLIPCHILDREN
   win_AxInit()
   ::hWnd := WAPI_CreateWindowEX( 0, "AtlAxWin", cProgId, nStyle, nLeft, nTop, nWidth, nHeight, hWnd, 0 )
   /* WAPI_SetWindowPos( ::hWnd, WIN_HWND_TOPMOST, 0, 0, 1, 1, hb_bitOr( WIN_SWP_NOSIZE, WIN_SWP_DRAWFRAME ) ) */
   ::oOLE := WIN_AxGetControl( ::hWnd, { | event, ... | ::Event( event, ... ) }, cID )
   RETURN self

PROCEDURE Event( ... ) CLASS HActiveX
   LOCAL cEvents := ""
   LOCAL aEvents := { ... }
   aEval( aEvents, { | xEvent | cEvents += HB_ValToStr( xEvent ) + ", " } )
   wapi_OutputDebugString( cEvents )
   RETURN

METHOD OnError() CLASS HActiveX
   RETURN HB_ExecFromArray( ::oOLE, __GetMessage(), HB_AParams() )

METHOD Close() CLASS HActiveX
   wapi_OutputDebugString( "Close" )
   WAPI_DestroyWindow( ::hWnd )
   ::hWnd := NIL
   ::oOLE := NIL
   wapi_OutputDebugString( "After Close" )
   RETURN NIL
