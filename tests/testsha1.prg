/*
 * $Id: testsha1.prg 14676 2010-06-03 16:23:36Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Rewritten from C: Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 */

PROCEDURE Main()

   ? ">" + hb_sha1( "hello" ) + "<"
   ? ">" + hb_sha1( "hello", .F. ) + "<"
   ? ">" + hb_sha1( "hello", .T. ) + "<"

   ? ">" + hb_hmac_sha1( "hello", "key" ) + "<"
   ? ">" + hb_hmac_sha1( "hello", "key", .F. ) + "<"
   ? ">" + hb_hmac_sha1( "hello", "key", .T. ) + "<"

   RETURN
