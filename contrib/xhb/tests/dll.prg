/*
 * $Id: dll.prg 16782 2011-05-18 07:50:42Z vszakats $
 */

#include "hbdll.ch"

IMPORT STATIC MessageBox( hWnd, cMsg, cText, nFlags ) FROM user32.dll EXPORTED AS MessageBoxA

PROCEDURE Main()
   ? MessageBox( 0, "Hello world!", "Harbour sez" )
   RETURN
