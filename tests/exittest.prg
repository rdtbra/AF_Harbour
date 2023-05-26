//
// $Id: exittest.prg 1519 1999-10-04 18:46:41Z vszel $
//

// quick exit test

function main
local x := 0

do while x < 10
   ++x
   if x == 5
      exit
   endif
enddo

qout("do exit test",iif(x == 5,"passed","fail"))

for x := 1 to 10
   if x == 5
      exit
   endif
next

qout("for exit test",iif(x == 5,"passed","fail"))

return nil
