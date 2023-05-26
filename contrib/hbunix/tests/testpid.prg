/*
 * $Id: testpid.prg 15870 2010-11-23 22:58:58Z vszakats $
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

    ? posix_getpid()

    RETURN
