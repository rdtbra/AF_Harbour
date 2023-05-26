/*
 * $Id: gtwin.prg 14676 2010-06-03 16:23:36Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test code for using more then one console window.
 *    It needs GT driver which supports such functionality, i.e.
 *    GTWVT in MS-Windows or GTXWC in XWindow.
 *
 * Copyright 2008 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */

#include "box.ch"

#ifdef __PLATFORM__WINDOWS
   REQUEST HB_GT_WVT_DEFAULT
   #define THREAD_GT "WVT"
#else
   REQUEST HB_GT_STD_DEFAULT
   #define THREAD_GT "XWC"
#endif

proc main()
   local pGT, pGT1, pGT2

   ? "This is small test for using more then one console window."
   ? "It needs GT which supports such functionality i.e. GTWVT in"
   ? "MS-Windows or GTXWC in XWindow"
   wait

   ? "Create two new GTs:"
   pGT1 := hb_gtCreate( THREAD_GT )
   ? "1 =>", pGT1
   pGT2 := hb_gtCreate( THREAD_GT )
   ? "2 =>", pGT1

   pGT := hb_gtSelect( pGT1 )
   SetColor( "W+/R" )
   dispBox( 10, 10, 20, 50, B_DOUBLE + " " )
   ?? "This test is shown in 1-st GT window"

   hb_gtSelect( pGT2 )
   SetColor( "W+/B" )
   dispBox( 15, 30, 20, 70, B_DOUBLE + " " )
   ?? "This test is shown in 2-nd GT window"

   hb_gtSelect( pGT )
   ? "New console window should be visible now"
   wait

   ? "Destroy 1-st window..."
   pGT1 := NIL
   ?? "done"
   wait

   ? "Destroy 2-nd window..."
   pGT2 := NIL
   ?? "done"

   wait "Press any key to exit"

return
