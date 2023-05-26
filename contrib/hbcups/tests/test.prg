/*
 * $Id: test.prg 14380 2010-04-23 12:32:44Z vszakats $
 */

PROCEDURE Main()
   LOCAL i

   ? "Default printer:", cupsGetDefault()

   FOR EACH i IN cupsGetDests()
      ? i:__enumIndex(), i
   NEXT

   ? "Printing... Job ID:", cupsPrintFile( cupsGetDefault(), "test.prg", "Harbour CUPS Printing", { "sides=one-sided" } )
/* ? "Printing... Job ID:", cupsPrintFile( cupsGetDefault(), "test.prg", "Harbour CUPS Printing", { "sides" => "one-sided" } ) */

   RETURN
