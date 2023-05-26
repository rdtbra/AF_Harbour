/*
 * $Id: testgs.prg 16436 2011-03-07 14:07:20Z vszakats $
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
    LOCAL a, b, c, d

    ? HB_GSAPI_REVISION( @a, @b, @c, @d )

    ? a
    ? b
    ? c
    ? d

    ? HB_GS( { "--version" } )

    RETURN
