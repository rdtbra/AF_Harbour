/*
 * $Id: testres.prg 16374 2011-02-25 02:43:16Z vouchcac $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Carlos Bacco <carlosbacco at gmail.com>
 * www - http://harbour-project.org
 *
 */

#include "hbqtgui.ch"

#include "hbtrace.ch"

#include "common.ch"

STATIC s_qApp
STATIC s_re1

INIT PROCEDURE Qt_Start()
   s_qApp := QApplication()
   s_re1 := QResource()
   s_re1:registerResource_1( HBQTRES_TESTRES() )
   RETURN

EXIT PROCEDURE Qt_End()
   s_re1:unregisterResource_1( HBQTRES_TESTRES() )
   RETURN

PROCEDURE Main()
   LOCAL oWnd
   LOCAL oDA
   LOCAL lb1
   LOCAL ly1

   oWnd := QMainWindow()
   oWnd:setWindowIcon( ":harbour-icon.png" )

   oDA := QWidget()
   oWnd:setCentralWidget( oDA )

   lb1 := Qlabel()
   lb1:setAlignment( hb_bitOr( Qt_AlignHCenter, Qt_AlignVCenter ) )
   lb1:setPixMap( QPixMap( ":harbour-logo.png" ) )

   ly1 := QVBoxLayout( oDA )
   ly1:addWidget( lb1 )

   oWnd:Show()
   s_qApp:exec()

   RETURN
