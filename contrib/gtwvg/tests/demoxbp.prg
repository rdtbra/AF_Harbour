/*
 * $Id: demoxbp.prg 13031 2009-11-26 22:12:44Z vouchcac $
 */

/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
//
//                                EnOnkar
//                          ( The Lord is ONE )
//                                   .
//            Xbase++ Compatible XbpDialog() based Application
//
//                  Pritpal Bedi <pritpal@vouchcac.com>
//                              08Dec2008
//
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include "inkey.ch"
#include "common.ch"
#include "wvtwin.ch"
#include "hbgtinfo.ch"
#include "hbgtwvg.ch"
#include "wvgparts.ch"

/*----------------------------------------------------------------------*/

FUNCTION Main()
   Local oCrt, oTBar, oSBar, oStatic, oCom, oXbp, oTree, oItem1, oItem2
   LOCAL oListBox, oCheck, oRadio, oStatic2, oMLE, oAddr
   LOCAL oPanel, oPanel1, oPanel2, cText, cNavigate, oDA
   LOCAL cVarA  := "Test A", cVarB := "Test B"
   LOCAL aState := {"not selected", "selected", "undefined"}
   LOCAL aParts := {}

   //--------------------------- Dialog -------------------------------\\
   oCrt := WvgDialog():new( , , { 30,30 }, { 900,600 }, , .t. )
   oCrt:closable := .t.
   oCrt:icon := "vr_1.ico"
   oCrt:create()

   oCrt:setFontCompoundName( '12.Courier italic' )

   oDA := oCrt:drawingArea

   //--------------------------- Menu --------------------------------\\
   ActiveXBuildMenuXbp( oCrt, @oStatic, @oStatic2 )

   //--------------------------- ToolBar -----------------------------\\
   oTBar := ActiveXBuildToolBarXbp( oDA )

   //--------------------------- StatusBar ---------------------------\\
   oSBar   := WvgStatusBar():new( oCrt ):create( , , , , , .t. )
   oSBar:panelClick := {|oPanel| WVG_MessageBox( , oPanel:caption ) }
   oPanel  := oSBar:getItem( 1 )
   oPanel:caption := 'My Root Panel'
   oPanel1 := oSBar:addItem()
   oPanel1:caption := 'Ready'
   oPanel2 := oSBar:addItem()
   oPanel2:caption := 'Click on any part!'

   //--------------------------- Static ------------------------------\\
   oStatic := WvgStatic():new( oDA )
   oStatic:type    := WVGSTATIC_TYPE_TEXT
   oStatic:options := WVGSTATIC_TEXT_CENTER
   oStatic:caption := chr(13)+'Implemented   Xbase++ Parts'

   oStatic:create( , , { 0, oTBar:currentSize()[2]+3 }, { 120, oCrt:currentSize()[2]-;
                               oTBar:currentSize()[2]-oSBar:currentSize()[2]-4 }, , .t. )
   oStatic:setColorBG( RGB( 200,200,200 ) )

   //--------------------------- ListBox -----------------------------\\
   oListBox := WvgListBox():new()
   oListBox:create( oStatic, , { 5, 55 }, { 107, 380 } )

   oListBox:setColorFG( RGB( 218,61,34 ) )
   //oListBox:setColorBG( RGB( 250,244,182 ) )

   aadd( aParts, 'XbpDialog'        )
   aadd( aParts, 'XbpMenuBar'       )
   aadd( aParts, 'XbpToolBar'       )
   aadd( aParts, 'XbpToolBarButton' )
   aadd( aParts, 'XbpStatusBar'     )
   aadd( aParts, 'XbpStatic'        )
   aadd( aParts, 'XbpTreeView'      )
   aadd( aParts, 'XbpTreeViewItem'  )
   aadd( aParts, 'XbpActiveXControl')
   aadd( aParts, 'XbpListBox'       )
   aadd( aParts, 'XbpPushButton'    )
   aadd( aParts, 'XbpCheckBox'      )
   aadd( aParts, 'XbpRadioButton'   )
   aadd( aParts, 'Xbp3State'        )
   aadd( aParts, 'XbpSLE'           )
   aadd( aParts, 'XbpMLE'           )
   aadd( aParts, 'XbpHTMLViewer'    )
   aadd( aParts, 'XbpSysWindow'     )
   aadd( aParts, 'XbpFontDialog'    )
   aadd( aParts, 'XbpFont'          )
   aadd( aParts, '-------------'    )
   aadd( aParts, 'DataRef'          )

   aeval( aParts, {|e| oListBox:addItem( e ) } )
   oListBox:itemSelected := {|| WVG_MessageBox( , oListBox:getCurItem() ) }
   oListBox:setData( 3 )    // show selected 'XbpToolBar'

   //--------------------------- PushButton --------------------------\\
   oXbp := WvgPushButton():new( oStatic )
   oXbp:caption := "Hide"
   oXbp:create( , , { 20,440 }, {80,30} )
   oXbp:activate:= {|| oStatic:hide(), oCrt:sendMessage( WM_SIZE, 0, 0 ) }

   //--------------------------- TreeView ---------------------------\\

   oTree := WvgTreeView():new( oDA, , { oCrt:currentSize()[1]-160,oTBar:currentSize()[2]+3 }, ;
                                       { 160, oCrt:currentSize()[2]-;
                               oTBar:currentSize()[2]-oSBar:currentSize()[2]-4 }, , .t. )
   oTree:hasLines   := .T.
   oTree:hasButtons := .T.
   oTree:alwaysShowSelection := .T.
   oTree:create()
   oTree:setColorBG( RGB( 120,15,240 ) )
   oTree:setColorFG( RGB( 15,240,120 ) )
   oTree:itemSelected := {|oItem| IF( oItem <> NIL, WVG_MessageBox( , oItem:caption ), NIL ) }

   oItem1 := oTree:rootItem:addItem( "First level A" )

   oTree:rootItem:addItem( "First level B" )

   oItem2 := oItem1:addItem( "Second level A" )
   oItem1:addItem( "Second level B" )

   oItem2:addItem( "Third level A" )
   oItem2:addItem( "Third level B" )
   oItem2:addItem( "Third level C" )

   #if 0
   oItem1:expand( .t. )
   #else
   oTree:showExpanded( .t., 2 )
   #endif

   oTree:setData( oItem2 )

   //--------------------------- Active-X ---------------------------\\
   hb_gtInfo( HB_GTI_WINTITLE, 'http://www.harbour.vouch.info' )
   #if 0
   oCom := WvgActiveXControl():New( oDA, , { 0, 0 }, { 100, 100 }, , .t. )
   oCom:CLSID := 'Shell.Explorer.2'
   oCom:mapEvent( 269, {|| QOut( ' E X P L O R E R - 2 6 9' ) } )
   #else
   oCom := WvgHTMLViewer():New( oDA, , { 0, 0 }, { 100, 100 }, , .t. )
   oCom:beforeNavigate := {|cURL, x, oHTML| x := x, oHTML := oHTML, oPanel:caption := cURL }
   oCom:statusTextChange := {|cText| oPanel:caption := cText }
   #endif
   oCom:create()
   oCom:Navigate( 'http://www.harbour.vouch.info' )

   oAddr := WvgSLE():new()
   oAddr:bufferLength := 500
   oAddr:border       := .t.
   cNavigate          := 'http://www.harbour.vouch.info'
   oAddr:dataLink     := {|x| iif( x == NIL, cNavigate, cNavigate := x ) }
   oAddr:setColorFG( RGB( 0,0,255   ) )
   oAddr:setColorBG( RGB( 0,255,255 ) )
   oAddr:create( oDA, , { 120, oTBar:currentSize()[2] }, { 500,20 }, , .t. )
   oAddr:setData()
   oAddr:killInputFocus := {|m1,m2,oS| m1:=m1, m2:=m2, oS:getData(), oCom:navigate( cNavigate ) }

   //----------------- Panel : Static + Radio + Checkbox ----------\\
   oStatic2:= WvgStatic():New( oDA, , { 150, 150 }, { 500,310 }, , .f. )
   //oStatic2:type    := WVGSTATIC_TYPE_RAISEDBOX //BGNDFRAME
   oStatic2:exStyle += WS_EX_WINDOWEDGE
   //oStatic2:options := WVGSTATIC_FRAMETHICK
   oStatic2:create()
   oStatic2:setColorBG( RGB( 175,175,175 ) )

   oXbp    := WvgPushButton():new( oStatic2 )
   oXbp:caption     := "Hide"
   oXbp:caption     := "Hide"
   oXbp:create( , , { 430,275 }, { 60,25 } )
   oXbp:activate    := {|| oStatic2:hide(), oCrt:sendMessage( WM_SIZE, 0, 0 ) }

   oRadio  := WvgRadioButton():new( oStatic2,, { 10,10 }, { 100,15 } )
   oRadio:caption   := "Com 1"
   oRadio:selection := .T.
   oRadio:selected  := {|m1,m2,obj| m1:=m1, m2:=m2, WVG_MessageBox( , obj:caption + IF( obj:selection, '< S >', '< N >' ) ) }
   oRadio:create()

   oRadio  := WvgRadioButton():new( oStatic2,, { 10,35 }, { 100,15 } )
   oRadio:caption   := "Com 2"
   oRadio:create()

   oCheck  := WvgCheckBox():New( oStatic2, , { 10,70 }, { 100,15 }, , .t. )
   oCheck:caption   := 'Checkbox A'
   oCheck:create()
   oCheck:selected  := {|m1,m2,o| m1:=m1,m2:=m2, WVG_MessageBox( , IF( o:getData(), 'I am selected','I am not selected' ) ) }

   // Create first 3State button, passing the position to :create()
   oXbp    := Wvg3State():new()
   oXbp:caption := "3 State A"
   oXbp:create( oStatic2, , { 10,100 }, { 100,15 } )
   // Determine current state using mp1
   oXbp:selected := {| m1,m2,oBtn | m2:=m2, oBtn:=oBtn, oPanel1:caption := "3State A ["+aState[ m1+1 ]+"]" }

   // Create second 3State Button, passing the position to :new()
   oXbp    := Wvg3State():new( oStatic2, , { 10,125 }, { 100,15 } )
   oXbp:caption := "3 State B"
   oXbp:create( oStatic2 )
   // Determine current state using :getData()
   oXbp:selected := {| m1,m2,oBtn | m1:=m1,m2:=m2, WVG_MessageBox( , "3State B", aState[ oBtn:getData()+1 ] ) }

   // Create first SLE, specify position using :create()
   // On :typeOut set the focus to the second SLE
   oXbp                := WvgSLE():new()
   oXbp:autoTab        := .T.
   oXbp:bufferLength   := 20
   // Data code block containing assignment to LOCAL variable
   oXbp:dataLink       := {|x| IIf( x == NIL, cVarA, cVarA := x ) }
   oXbp:create( oStatic2, , { 10,170 }, { 150,20 } )
   oXbp:setData()
   // Assign the value of the edit buffer to a LOCAL variable when the input focus is lost
   oXbp:killInputFocus := { |x,y,oSLE| x:=x,y:=y, oSLE:getData(), oPanel:caption := "cVarA =" + cVarA }

   // Create second SLE, specify position using :new()
   oXbp                := WvgSLE():new( , , { 10,200 }, { 150,20 } )
   oXbp:tabStop        := .T.
   oXbp:bufferLength   := 15
   oXbp:dataLink       := {|x| IIf( x == NIL, cVarB, cVarB := x ) }
   oXbp:create( oStatic2 )
   oXbp:setData()
   oXbp:killInputFocus := { |x,y,oSLE| x:=x,y:=y, oSLE:getData(), oPanel:caption := "cVarB =" + cVarB }

   // Read file into LOCAL variable
   cText   := MemoRead( 'gtwvg.hbc' )
   // Create MLE, specify position using :create() and
   // assign data code block accessing LOCAL variable
   oMLE    := WvgMLE():new()
   oMLE:wordWrap := .F.
   oMLE:border   := .t.
   oMLE:dataLink := {|x| IIf( x==NIL, cText, cText := x ) }
   oMLE:create( oStatic2, , { 180,10 }, { 310,250 } )
   // Copy text from LOCAL variable into edit buffer via :dataLink
   oMLE:setData()

   //--------------------------- Misc Config ------------------------\\
   oTBar:buttonClick := {|oBtn| IF( oBtn:caption == 'Hide'   , oStatic:hide(), nil ),;
                                IF( oBtn:caption == 'Show'   , oStatic:show(), nil ),;
                                IF( oBtn:caption == 'Tools'  , oStatic2:show():toFront(), nil ),;
                                IF( oBtn:caption == 'FontDlg', ExeFontDialog( oCrt ), nil ),;
                                IF( oBtn:caption $ 'Hide,Show', oCrt:sendMessage( WM_SIZE, 0, 0 ), NIL ),;
                                    oPanel2:caption := "Button [ " + oBtn:caption + " ] clicked!" }

   oCrt:resize := {|| ResizeDialogXbp( oCrt, oTBar, oSBar, oStatic, oCom, oTree, oAddr ) }

   oCrt:sendMessage( WM_SIZE, 0, 0 )
   oCrt:show()

   DO WHILE .t.
      IF inkey() == 27
         EXIT
      ENDIF
   ENDDO

   oCrt:Destroy()
   Return nil

/*----------------------------------------------------------------------*/

STATIC FUNCTION ResizeDialogXbp( oCrt, oTBar, oSBar, oStatic, oCom, oTree, oAddr )
   LOCAL aCrt, aTBar, aSBar
   LOCAL nH, nT

   aCrt    := oCrt:currentSize()
   aTBar   := oTBar:currentSize()
   aSBar   := oSBar:currentSize()

   nT := aTBar[2]
   nH := aCrt[2] - aTBar[2] - aSBar[2]

   IF oStatic:isVisible
      oStatic:setPosAndSize( { 0, nT+3 }, { 120, nH-4 }, .t. )
      oAddr:setPosAndSize( { 120, nT+2 }, { aCrt[1]-120-150, 20 }, .t. )
      oCom:setPosAndSize( { 120, nT+2+20 }, { aCrt[1]-120-150, nH-20 }, .t. )
      oTree:setPosAndSize( { aCrt[1]-150, nT }, { 150, nH }, .t. )

   ELSE
      oAddr:setPosAndSize( { 0, nT+2 }, { aCrt[1]-150, 20 }, .t. )
      oCom:setPosAndSize( { 0, nT+2+20 }, { aCrt[1]-150, nH-20 }, .t. )
      oTree:setPosAndSize( { aCrt[1]-150, nT }, { 150, nH }, .t. )

   ENDIF

   RETURN 1

/*----------------------------------------------------------------------*/

Static Function ActiveXBuildMenuXbp( oCrt, oStatic, oStatic2 )
   Local oMenuBar, oSubMenu

   oMenuBar := WvgMenuBar():new( oCrt ):create()

   // Define submenu in procedural style.
   // The numeric index of the selected menu item
   // is passed to the Callback code block -> mp1

   oSubMenu       := WvgMenu():new( oMenuBar ):create()
   oSubMenu:title := "~Procedural"
   oSubMenu:addItem( { "Play Charge ~1", } )
   oSubMenu:addItem( { "Play Nannyboo ~2", } )
   oSubMenu:itemSelected := {|mp1| MyFunctionXbp( 100+mp1 ) }
   oMenuBar:addItem( { oSubMenu, NIL } )

   // Define submenu in the functional style:
   // A menu item executes a code block that
   // calls a function
   oSubMenu       := WvgMenu():new( oMenuBar ):create()
   oSubMenu:title := "~Functional"
   oSubMenu:addItem( { "Play Opening ~1", {|| MyFunctionXbp( 1 ) } } )
   oSubMenu:addItem( { "Play Closing ~2", {|| MyFunctionXbp( 2 ) } } )
   oSubMenu:addItem()
   oSubMenu:addItem( { "~MessageBox"    , {|| MyFunctionXbp( 3 ) } } )
   oMenuBar:addItem( { oSubMenu, NIL } )

   oSubMenu       := WvgMenu():new( oMenuBar ):create()
   oSubMenu:title := "F~eatures"
   oSubMenu:addItem( { "~Hide or Show Left Panel" , {|| IF( oStatic:isVisible, ;
                              oStatic:hide(), oStatic:show() ), oCrt:sendMessage( WM_SIZE,0,0 ) } } )
   oSubMenu:addItem( { "~Show My Panel" , {|| oStatic2:show():toFront() } } )
   oSubMenu:addItem()
   oSubMenu:addItem( { "~Font Dialog"   , {|| ExeFontDialog( oCrt ) } } )

   oMenuBar:addItem( { oSubMenu, NIL } )

   Return nil
/*----------------------------------------------------------------------*/

STATIC FUNCTION ActiveXBuildToolBarXbp( oCrt )
   LOCAL oTBar

   oTBar := WvgToolBar():new( oCrt , , { 0,0 }, { 0,0 }, , .T. )

   oTBar:style        := WVGTOOLBAR_STYLE_FLAT

   oTBar:borderStyle  := WVGFRAME_RECT

   oTBar:buttonWidth  := 28
   oTBar:buttonHeight := 26

   oTBar:imageWidth   := 26
   oTBar:imageHeight  := 24

   oTBar:showToolTips := .t.

   oTBar:create()

   oTBar:addItem( "New"       , hb_DirBase() + 'v_new.bmp'    )
   oTBar:addItem( "Select"    , hb_DirBase() + 'v_selct1.bmp' )
   oTBar:addItem( )
   oTBar:addItem( "FontDlg"   , hb_DirBase() + 'v_calend.bmp' )
   oTBar:addItem( "Tools"     , hb_DirBase() + 'v_lock.bmp'   )
   oTBar:addItem( "Index"     , hb_DirBase() + 'v_index.bmp'  )
   oTBar:addItem( )
   oTBar:addItem( "Show"      , hb_DirBase() + 'v_clclt.bmp'  )
   oTBar:addItem( "Hide"      , hb_DirBase() + 'v_notes1.bmp' )

   RETURN oTBar

/*----------------------------------------------------------------------*/

Static Function MyFunctionXbp( nMode )

   #define MUSIC_WAITON          {800, 1600}

   do case
   case nMode == 1
      tone( MUSIC_WAITON[1], 1 )
      tone( MUSIC_WAITON[2], 1 )

   case nMode == 2
      tone( MUSIC_WAITON[2], 1 )
      tone( MUSIC_WAITON[1], 1 )

   case nMode == 3
      WVG_MessageBox( , "Button clicked!" )

   case nMode == 101  // Charge
      Eval( {|| tone(523,2),tone(698,2),tone(880,2),tone(1046,4),tone(880,2),tone(1046,8) } )

   case nMode == 102  // NannyBoo
      AEval( {{196,2},{196,2},{164,2},{220,2},{196,4},{164,4}}, {|a| tone(a[1],a[2]) } )

   case nMode == 103  // BADKEY
      tone( 480,0.25 )
      tone( 240,0.25 )

   endcase

   Return nil

/*----------------------------------------------------------------------*/

STATIC FUNCTION ExeFontDialog( oCrt )
   LOCAL oFontDlg, oWvgFont

   STATIC nMode := 0

   oFontDlg := WvgFontDialog():new( oCrt )

   oFontDlg:title            := 'Select a Screen Font'
   oFontDlg:aPos             := { 150,150 }
   oFontDlg:buttonApply      := .t.
   oFontDlg:activateApply    := {|| NIL }
   oFontDlg:familyName       := "Courier New"
   oFontDlg:strikeout        := .T.
   oFontDlg:underscore       := .f.
   //oFontDlg:activateOk       := {|| WVG_MessageBox( , 'activateOK Event Handelled in Windows!' ) }
   oFontDlg:nominalPointSize := 12

   //oFontDlg:size             := .f.
   //oFontDlg:style            := .f.

   oFontDlg:create()

   //  Every 2nd FontDialog will be MODAL
   oWvgFont := oFontDlg:display( ++nMode % 2 )

   HB_SYMBOL_UNUSED( oWvgFont )

   oFontDlg:destroy()

   RETURN nil

/*----------------------------------------------------------------------*/

STATIC FUNCTION HB_GTSYS()

   REQUEST HB_GT_GUI_DEFAULT
   REQUEST HB_GT_WVG
   REQUEST HB_GT_WVT
   REQUEST HB_GT_WGU

   RETURN NIL

/*----------------------------------------------------------------------*/
