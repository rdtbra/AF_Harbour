//
// $Id: statinit.prg 11201 2009-06-03 10:26:40Z vszakats $
//

// ; Donated to the public domain by
//   Viktor Szakats (harbour.01 syenar.hu)

MEMVAR cMyPubVar

STATIC bBlock1 := {|| Hello() }
STATIC bBlock2 := {|| cMyPubVar }

FUNCTION Main()

   PUBLIC cMyPubVar := "Printed from a PUBLIC var from a codeblock assigned to a static variable."

   Eval( bBlock1 )
   ? Eval( bBlock2 )

   RETURN NIL

FUNCTION Hello()

   ? "Printed from a codeblock assigned to a static variable."

   RETURN NIL
