/*
 * $Id: stress.prg 16703 2011-05-01 19:44:30Z vszakats $
 */

/* VERY IMPORTANT: Don't use this query as sample, they are used for stress tests !!! */

#include "simpleio.ch"

PROCEDURE Main()

   LOCAL oServer, oQuery, oRow, i, x

   LOCAL cServer := "localhost:"
   LOCAL cDatabase
   LOCAL cUser := "SYSDBA"
   LOCAL cPass := "masterkey"
   LOCAL nPageSize := 1024
   LOCAL cCharSet := "WIN1251"
   LOCAL nDialect := 1
   LOCAL cQuery, cName

   CLEAR SCREEN

   hb_FNameSplit( hb_argv( 0 ), NIL, @cName, NIL )
   cDatabase := hb_DirTemp() + cName + ".fdb"

   IF ! hb_FileExists( cDatabase )
      ? FBCreateDB( cServer + cDatabase, cUser, cPass, nPageSize, cCharSet, nDialect )
   ENDIF

   ? "Connecting..."

   oServer := TFBServer():New( cServer + cDatabase, cUser, cPass, nDialect )

   IF oServer:NetErr()
      ? oServer:Error()
      QUIT
   ENDIF

   IF oServer:TableExists( "test" )
      ? oServer:Execute( "DROP TABLE Test" )
      ? oServer:Execute( "DROP DOMAIN boolean_field" )
   ENDIF

   ? "Creating domain for boolean fields..."

   ? oServer:Execute("create domain boolean_field as smallint default 0 not null check (value in (0,1))")

   ? "Creating test table..."
   cQuery := "CREATE TABLE test("
   cQuery += "     Code SmallInt not null primary key, "
   cQuery += "     dept Integer, "
   cQuery += "     Name Varchar(40), "
   cQuery += "     Sales boolean_field, "
   cQuery += "     Tax Float, "
   cQuery += "     Salary Double Precision, "
   cQuery += "     Budget Numeric(12,2), "
   cQuery += "     Discount Decimal(5,2), "
   cQuery += "     Creation Date, "
   cQuery += "     Description blob sub_type 1 segment size 40 ) "

   ? "CREATE TABLE:", oServer:Execute( cQuery )

   oQuery := oServer:Query( "SELECT code, dept, name, sales, salary, creation FROM test" )

   oServer:StartTransaction()

   FOR i := 1 TO 10000
      @ 15, 0 say "Inserting values...." + hb_ntos( i )

      oRow := oQuery:Blank()

      oRow:Fieldput(1, i)
      oRow:Fieldput(2, i+1)
      oRow:Fieldput(3, "DEPARTMENT NAME " + strzero( i ) )
      oRow:Fieldput(4, (i % 10) == 0)
      oRow:Fieldput(5, 3000 + i )
      oRow:fieldput(6, Date() )

      oServer:Append( oRow )

      IF i % 100 == 0
         oServer:Commit()
         oServer:StartTransaction()
      ENDIF
   NEXT

   FOR i := 5000 TO 7000
      @ 16,0 say "Deleting values...." + str( i )

      oRow := oQuery:Blank()
      oServer:Delete( oRow, "code = " + str( i ) )

      IF i % 100 == 0
         oServer:Commit()
         oServer:StartTransaction()
      ENDIF
   NEXT

   FOR i := 2000 TO 3000
      @ 17,0 say "Updating values...." + str( i )

      oRow := oQuery:Blank()
      oRow:Fieldput( 5, 4000 + i )
      oServer:update( oRow, "code = " + str( i ) )

      IF i % 100 == 0
         oServer:Commit()
         oServer:StartTransaction()
      ENDIF
   NEXT

   oQuery := oServer:Query( "SELECT sum(salary) sum_salary FROM test WHERE code between 1 and 4000" )

   IF ! oQuery:Neterr()
      oQuery:Fetch()
      @ 18,0 say "Sum values...." + Str( oQuery:Fieldget( 1 ) )
      oQuery:Destroy()
   ENDIF

   x := 0
   FOR i := 1 TO 4000
      oQuery := oServer:Query( "SELECT * FROM test WHERE code = " + str( i ) )

      IF ! oQuery:Neterr()
         oQuery:Fetch()
         oRow := oQuery:getrow()

         oQuery:destroy()
         x += oRow:fieldget( oRow:fieldpos( "salary" ) )

         @ 19,0 say "Sum values...." + str( x )
      ENDIF
   NEXT

   oServer:Destroy()

   ? "Closing..."

   RETURN
