//
// $Id: testhrb.prg 11449 2009-06-20 09:37:56Z vszakats $
//

// see also exthrb.prg


#include "hbhrb.ch"

Procedure Main(x)
Local pHrb, cExe := "Msg2()", n

  n:=iif(x==NIL,0,val(x))

  ? "calling Msg ... From exe here !"
  Msg()
  ? "========================="

//  ? "Loading('exthrb.hrb' )"
//  pHrb := hb_HrbLoad("exthrb.hrb" )

//  ? "Loading(HB_HRB_BIND_DEFAULT,'exthrb.hrb' )"
//  pHrb := hb_HrbLoad(HB_HRB_BIND_DEFAULT,"exthrb.hrb" )

//  ? "Loading(HB_HRB_BIND_LOCAL,'exthrb.hrb' )"
//  pHrb := hb_HrbLoad(HB_HRB_BIND_LOCAL,"exthrb.hrb" )

  ? "Loading("+iif(n=0,"HB_HRB_BIND_DEFAULT",iif(n=1,"HB_HRB_BIND_LOCAL","HB_HRB_BIND_OVERLOAD"))+",'exthrb.hrb' )"
  pHrb := hb_HrbLoad(n,"exthrb.hrb" )

  ? "========================="

  ? "calling Msg ... DEFAULT=From exe, LOCAL=From exe, OVERLOAD=From HRB"
  Msg()
  ? "========================="

  ? "calling Msg ... DEFAULT=From exe, LOCAL=From HRB, OVERLOAD=From HRB"
  &cExe  //
  ? "========================="

  hb_HrbUnload( pHrb ) // should do nothing in case of OVERLOAD

  ? "calling Msg ... DEFAULT=From exe, LOCAL=From exe, OVERLOAD=From HRB"
  Msg() // test unload protection when using OVERLOAD ... then .hrb not anymore unloadable
  ? "========================="

  ?  "END"

Return


Function Msg()
? "Function called from Exe"
Return .T.
