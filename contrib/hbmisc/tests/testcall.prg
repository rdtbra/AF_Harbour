/*
 * $Id: testcall.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

PROCEDURE Main()
   LOCAL nFlags

   nFlags := -1
   ? CALLDLL32( "InternetGetConnectedState", "wininet.dll", @nFlags, 0 )
   ? nFlags

   RETURN
