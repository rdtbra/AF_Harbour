//
// $Id: testerro.prg 1519 1999-10-04 18:46:41Z vszel $
//

// Testing Harbour Error system

function Main()

   local n

   QOut( "We are running and now an error will raise" )

   n++      // an error should raise here

return nil
