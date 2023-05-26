//NOTEST
//
// $Id: test10.prg 1519 1999-10-04 18:46:41Z vszel $
//

// compile this using Harbour /10 flag

Function Main()

   QOut( MyReplicatZZ( 'a', 10 ) )

return NIL

Function MyReplicator( cChar, nLen )

return Replicate( cChar, nLen )
