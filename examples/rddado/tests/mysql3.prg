/*
 * $Id: mysql3.prg 9217 2008-08-23 15:02:49Z vszakats $
 */

// Testing LOCATE and CONTINUE

#include "adordd.ch"

REQUEST ADORDD

function Main()

   USE test00 VIA "ADORDD" TABLE "ACCOUNTS" MYSQL ;
      FROM "www.freesql.org" USER "myuser" PASSWORD "mypass"

   LOCATE FOR "City LIKE 'Chi*'"

   while ! Eof()
      ? test00->First, test00->City
      CONTINUE
   end   

   USE

return nil
