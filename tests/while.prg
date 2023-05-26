//
// $Id: while.prg 1519 1999-10-04 18:46:41Z vszel $
//

// while loop test

function Main()

   local x := 0

   while x++ < 1000
      QOut( x )
   end

return nil
