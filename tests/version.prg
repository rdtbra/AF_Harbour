/*
 * $Id: version.prg 15174 2010-07-25 08:45:50Z vszakats $
 */

/* Testing the VERSION function */
/* Harbour Project source code
   http://harbour-project.org/
   Donated to the public domain by David G. Holm <dholm@jsd-llc.com>.
*/

PROCEDURE Main()

   outstd( chr( 34 ) + version() + chr( 34 ) + hb_eol() )
   outstd( chr( 34 ) + hb_compiler() + chr( 34 ) + hb_eol() )
   outstd( chr( 34 ) + os() + chr( 34 ) + hb_eol() )

   RETURN
