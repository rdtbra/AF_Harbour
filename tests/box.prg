//
// $Id: box.prg 1519 1999-10-04 18:46:41Z vszel $
//

// Testing Harbour device management.

#include "box.ch"
function Main()

   dispbox( 1, 1, 5, 5, B_SINGLE + 'X', 'color not supported')
   dispbox( 7, 7, 13, 72, B_DOUBLE + '.')
   dispbox( 14, 14, 22, 22, B_SINGLE_DOUBLE )

return nil
