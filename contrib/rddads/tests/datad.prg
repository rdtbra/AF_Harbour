/*
 * $Id: datad.prg 16849 2011-06-03 15:21:00Z vszakats $
 */

/*
    Demo of ADS Connection handling and Data Dictionaries
*/

#include "ads.ch"
REQUEST ADS

#if defined( __HBDYNLOAD__RDDADS__ )
#  include "rddads.hbx"
#endif

PROCEDURE MAIN()

   LOCAL n
   LOCAL cErr, cStr
   LOCAL aStru := { { "ID", "A", 1, 0 }, { "Name", "C", 50, 0 }, { "address", "C", 50, 0 }, { "city", "C", 30, 0 }, { "Age", "n", 3, 0 } }
   LOCAL hConnection1

#if defined( __HBDYNLOAD__RDDADS__ )
   LOCAL l := hb_libLoad( hb_libName( "rddads" + hb_libPostfix() ) )

   hb_rddadsRegister()

   HB_SYMBOL_UNUSED( l )
#endif

   CLS

   rddSetDefault( "ADSADT" )
   AdsSetServerType( 7 )
   SET FILETYPE TO ADT

   ? "Default connection is 0:", adsConnection()

   FErase( "harbour.add" )
   FErase( "harbour.ai" )
   FErase( "harbour.am" )
   FErase( "Table1.adt" )
   FErase( "Table1.adi" )
   FErase( "Table2.adt" )
   FErase( "Table2.adi" )

   // now Create a Data dictionary and the files if not exist
   IF ! hb_FileExists( "harbour.add" )

      ADSDDCREATE( "harbour.add", , "Harbour ADS demo for data dictionary" )
      // This also creates an Administrative Handle that is set as the default
      ? "Default connection is now this admin handle:", adsConnection()
      AdsDisconnect()   // disconnect current default.
      // if you wanted to retain this connection for later, you could use
      // hAdminCon := adsConnection(0)
      // This get/set call would return the current connection, then set it to 0

      ? "Default connection is now this handle (zero):", adsConnection()

      // now create two free tables with same structure
      dbCreate( "Table1", aStru )
      dbCreate( "Table2", aStru )
      //now create an index
      USE table1 NEW
      INDEX ON FIELD->id TAG codigo
      USE

      USE table2 NEW
      INDEX ON FIELD->id TAG codigo
      USE
   ENDIF

   // now the magic
   IF adsConnect60( "harbour.add", 7; /* All types of connection*/
      , "ADSSYS", "", , @hConnection1 )
      // The connection handle to harbour.add is now stored in hConnection1,
      // and this is now the default connection

      ? "Default connection is now this handle:", adsConnection()
      ? "   Is it a Data Dict connection?  (ADS_DATABASE_CONNECTION=6, "
      ? "      ADS_SYS_ADMIN_CONNECTION=7):", AdsGetHandleType()

      // Add one user
      AdsDDCreateUser( , "Luiz", "papael", "This is user Luiz" )


      IF adsddGetUserProperty( "Luiz", ADS_DD_COMMENT, @cStr, hConnection1 )
         ? "User comment:", cStr
      ELSE
         ? "Error retrieving User comment"
      ENDIF


      ? "Add the tables"
      AdsDDaddTable( "Table1", "table1.adt", "table1.adi" )
      ?
      IF ! AdsDDaddTable( "Customer Data", "table2.adt", "table2.adi" )
         // notice the "long table name" for file Table2.adt.  Later open it with "Customer Data" as the table name
         ? "Error adding table:", adsGetLastError( @cErr ), cErr
      ENDIF
      ? "Set new admin pword on default  connection:", AdsDDSetDatabaseProperty( ADS_DD_ADMIN_PASSWORD, "newPWord"  )
      ? "Set new admin pword on explicit connection:", AdsDDSetDatabaseProperty( ADS_DD_ADMIN_PASSWORD, "newPWord", hConnection1  )
      ? "Clear admin pword:", AdsDDSetDatabaseProperty( ADS_DD_ADMIN_PASSWORD, ""  )

   ELSE
      ? "Error connecting to harbour.add!"
   ENDIF
   AdsDisconnect( hConnection1 )
   hConnection1 := NIL     // you should always reset a variable holding a handle that is no longer valid

   ? "Default connection is back to 0:", adsConnection()
   ? "Is a Data Dict connection? (AE_INVALID_HANDLE = 5018):", AdsGetHandleType()

   // now open the tables and put some data

   IF AdsConnect60( "harbour.add", 7; /* All types of connection*/
      , "Luiz", "papael", , @hConnection1 )
      ? "Default connection is now this handle:", adsConnection()
      ? "Connection type?", AdsGetHandleType()

      FOR n := 1 TO  100
         IF AdsCreateSqlStatement( "Data2", 3 )
            IF ! AdsExecuteSqlDirect( " insert into Table1( name,address,city,age) VALUES( '" + StrZero( n ) + "','" + StrZero( n ) + "','" + StrZero( n ) + "'," + Str( n ) + ")" )
               ShowAdsError()
            ENDIF
            USE
         ENDIF
      NEXT

      FOR n := 1 TO 100
         IF AdsCreateSqlStatement( "Data1", 3 )
            IF ! AdsExecuteSqlDirect( " insert into " + '"Customer Data"' + "( name,address,city,age) VALUES( '" + StrZero( n ) + "','" + StrZero( n ) + "','" + StrZero( n ) + "'," + Str( n ) + ")" )
               ShowAdsError()
            ENDIF
            USE
         ENDIF
      NEXT


      // AdsUseDictionary(.t.)  this function no longer is needed; the system knows if it's using a Data Dictionary connection

      // Open the "long table name" for Table2
      dbUseArea( .T. , , "Customer Data", "custom", .T. , .F. )
      ? "Press a key to browse", Alias()
      Inkey( 0 )
      Browse()
      USE
      USE table1 NEW
      Browse()
      USE
   ENDIF

   AdsDisconnect( hConnection1 )

   RETURN

PROCEDURE ShowAdsError()

   LOCAL cMsg

   AdsGetLastError( @cMsg )

   Alert( cMsg )

   RETURN
