/*
 * $Id: sound.prg 1519 1999-10-04 18:46:41Z vszel $
 */

function main()
local start := seconds(), stop
   qout( "start   ", start )
   tone( 440, 9.1 )
   tone( 880, 9.1 )
   tone( 440, 9.1 )
   stop := seconds()
   qout( "stop    ", stop )
   qout( "duration", ( stop - start ), "(should be close to 1.5)" )
return nil
