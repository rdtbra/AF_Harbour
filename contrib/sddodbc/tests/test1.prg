/*
 * $Id: test1.prg 14271 2010-04-05 09:16:23Z vszakats $
 */

#include "simpleio.ch"
#include "hbrddsql.ch"

REQUEST SDDODBC, SQLMIX

PROC main()
   RDDSETDEFAULT( "SQLMIX" )
   SET( _SET_DATEFORMAT, "yyyy-mm-dd" )
   ? "Connect:", RDDINFO( RDDI_CONNECT, { "ODBC", "DBQ=" + hb_DirBase() + "..\..\hbodbc\tests\test.mdb;Driver={Microsoft Access Driver (*.mdb)}" } )
   ? "Use:", DBUSEAREA( .T.,, "select * from test", "test" )
   ? "Alias:", ALIAS()
   ? "DB struct:", HB_VALTOEXP( DBSTRUCT() )
   INKEY( 0 )
   BROWSE()

   INDEX ON FIELD->SALARY TO salary
   DBGOTOP()
   BROWSE()
   DBCLOSEAREA()
RETURN
