//
// $Id: statics2.prg 9188 2008-08-17 15:04:11Z vszakats $
//

// Statics overlapped!
//
// Compile statics1.prg, statics2.prg and link both files

static uA, uB

function Test()

   QOut( "INSIDE statics2.prg" )
   QOut( "   static uA, uB" )
   QOut( "" )
   QOut( "   ValType( uA ), ValType( uB ) =>", ValType( uA ), ",", ValType( uB ) )
   QOut( "   uA, uB =>", uA, ",", uB )
   uA := "a"
   uB := "b"
   QOut( '   uA := "a"' )
   QOut( '   uB := "b"' )
   QOut( "   uA, uB =>", uA, ",", uB )
   QOut( "" )

return nil
