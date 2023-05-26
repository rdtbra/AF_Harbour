/*
 * $Id: numline.prg 16343 2011-02-20 21:54:15Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2011 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE Main()

   ? NUMLINE( "" )                                                , 0
   ? NUMLINE( "-" )                                               , 1
   ? NUMLINE( Replicate( "-", 80 ) )                              , 2
   ? NUMLINE( Replicate( "-", 160 ) )                             , 3
   ? NUMLINE( Replicate( "-", 100 ), 30 )                         , 4
   ? NUMLINE( "-" + Chr( 13 ) + Chr( 10 ) )                       , 2
   ? NUMLINE( "-" + Chr( 10 ) )                                   , 2
   ? NUMLINE( "-" + Chr( 13 ) + Chr( 10 ) + "=" )                 , 2
   ? NUMLINE( "-" + Chr( 10 ) + "=" )                             , 2
   ? NUMLINE( Replicate( "-", 100 ) + Chr( 13 ) + Chr( 10 ), 30 ) , 5
   ? NUMLINE( Replicate( "-", 100 ) + Chr( 10 ), 30 )             , 5

   RETURN
