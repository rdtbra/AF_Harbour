//
// $Id: classch.prg 9020 2008-07-28 18:43:42Z vszakats $
//

// Testing Harbour hbclass.ch commands

#include "hbclass.ch"

//--------------------------------------------------------------------//

function Main()

   local o := TTest():New( "one", "two" )

   ? o:ClassName()
   ? o:One
   ? o:Two

   o:Test()

return nil

//--------------------------------------------------------------------//

CLASS TTest INHERIT TParent

   DATA One, Two, Three

   METHOD New( One, Two )

   METHOD Test() INLINE QOut( "Hello" )

ENDCLASS

//--------------------------------------------------------------------//

METHOD New( One, Two ) CLASS TTest

   Super:New()

   ::One := One
   ::Two := Two

return Self

//--------------------------------------------------------------------//

CLASS TParent

   DATA One

   METHOD New()

ENDCLASS

//--------------------------------------------------------------------//

METHOD New() CLASS TParent

   ? "TParent:New()"

return Self

//--------------------------------------------------------------------//
