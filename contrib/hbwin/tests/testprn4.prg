/*
 * $Id: testprn4.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE Main()
   LOCAL a := WIN_PRINTERGETDEFAULT()

   ? ">" + a + "<"

   ? WIN_PRINTERSETDEFAULT( a )

   RETURN
