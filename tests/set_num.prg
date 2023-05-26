/*
 * $Id: set_num.prg 15174 2010-07-25 08:45:50Z vszakats $
 */

// Testing SET

#include "set.ch"

function Main()
local n

   for n := 1 to _SET_COUNT
      outstd (hb_eol())
      outstd (set (n))
   next

return nil
