//
// $Id: arreval.prg 1519 1999-10-04 18:46:41Z vszel $
//

function Main()

   local a := { 100, 200, 300 }

   aEval(a, {|nValue, nIndex| QOut(nValue, nIndex) })

return nil

