/*
 * $Id: gtxfnt.prg 14676 2010-06-03 16:23:36Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test code for changing font in X-Window GTs
 *
 * Copyright 2009 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */

#include "hbgtinfo.ch"

REQUEST HB_GT_XWC_DEFAULT
proc main()
   local cChars, i, j, n

   cChars := ""
   for i := 0 to 7
      cChars += ";"
      for j := 0 to 31
         n := i * 32 + j
         cChars += iif( n == asc( ";" ), ",", ;
                   iif( n == 10, " ", chr( n ) ) )
      next
   next

   n := 2
   ? hb_gtVersion( 0 ), hb_gtVersion( 1 )
   while n == 2
      ? hb_gtInfo( HB_GTI_FONTSEL )
      hb_gtInfo( HB_GTI_FONTSEL, xFontSel() )
      n := alert( "What do you think about this font;;" + ;
                  hb_gtInfo( HB_GTI_FONTSEL ) + ";" + cChars, ;
                  { "FINE", "CHANGE" } )
   enddo
   ? "current font:"
   ? hb_gtInfo( HB_GTI_FONTSEL )
   outstd( hb_gtInfo( HB_GTI_FONTSEL ) )
   wait
return

function xfontsel()
   local hProcess, hStdOut, cFontSel, n
   hProcess := hb_processOpen( "xfontsel -print",, @hStdOut )
   if hProcess != -1
      cFontSel := space( 256 )
      n := fread( hStdOut, @cFontSel, len( cFontSel ) )
      cFontSel := left( cFontSel, n )
      hb_processClose( hProcess )
      fclose( hStdOut )
   endif
return cFontSel
