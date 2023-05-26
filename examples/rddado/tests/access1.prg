/*
 * $Id: access1.prg 14908 2010-06-26 08:32:23Z vszakats $
 */

#include "adordd.ch"

REQUEST ADORDD

PROCEDURE Main()

   SET DATE ANSI
   SET CENTURY ON

   USE ( hb_dirBase() + "test.mdb" ) VIA "ADORDD" TABLE "Table1"

   Browse()

   USE

   RETURN
