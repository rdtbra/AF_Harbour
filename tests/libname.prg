/*
 * $Id: libname.prg 15329 2010-08-06 13:16:35Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE Main()

   ? hb_LibName( NIL )
   ? hb_LibName( "" )
   ? hb_LibName( "name" )
   ? hb_LibName( "name.ext" )
   ? hb_LibName( "name." )
   ? hb_LibName( "name.ext", NIL )
   ? hb_LibName( "dir\name.ext", NIL )
   ? hb_LibName( "name.ext", "mydir" )
   ? hb_LibName( "dir\name.ext", "mydir" )
   ? hb_LibName( "name.ext", "mydir\" )
   ? hb_LibName( "dir\name.ext", "mydir\" )

   RETURN
