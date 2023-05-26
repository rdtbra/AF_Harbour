//
// $Id: exthrb.prg 11426 2009-06-19 12:25:44Z vszakats $
//

// see also testhrb.prg


Function Msg()
? "Function called from HRB file"
Return .T.

Function msg2()
Return Msg()
