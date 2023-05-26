//
// $Id: statfun.prg 1519 1999-10-04 18:46:41Z vszel $
//

// Testing a static function call

function Main()

   QOut( "From Main()" )

   SecondOne()

   QOut( "From Main() again" )

return nil

static function SecondOne()

   QOut( "From Second()" )

return nil
