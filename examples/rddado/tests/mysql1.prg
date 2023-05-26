/*
 * $Id: mysql1.prg 9217 2008-08-23 15:02:49Z vszakats $
 */

#include "adordd.ch"

REQUEST ADORDD

function Main()

   USE test00 VIA "ADORDD" TABLE "ACCOUNTS" MYSQL ;
      FROM "www.freesql.org" USER "myuser" PASSWORD "mypass"

   Browse()

   USE

return nil
