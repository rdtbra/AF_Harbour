/*
 * $Id: clasinh.prg 2186 2000-02-14 08:11:56Z vszel $
 */

#include "hbclass.ch"

function main()
   local oObject, oBase
   oObject := TAnyClass():New()
   oBase := TClassBase():New()
return nil

class TClassBase
   method New()
   method Test() INLINE Alert( "Test" )
endclass

method New() class TClassBase
return Self

class TAnyClass from TClassBase
   method New()
endclass

method New() class TAnyClass
   super:New()
   super:Test()
return Self