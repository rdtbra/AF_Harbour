/*
 * $Id: test.prg 16805 2011-05-20 13:52:06Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "hbexpat.ch"

PROCEDURE Main( cFileName )
   LOCAL p := XML_ParserCreate()
   LOCAL xData
   LOCAL v1, v2, v3

   IF cFileName == NIL
      cFileName := ".." + hb_ps() + ".." + hb_ps() + "hbide" + hb_ps() + "setup.ui"
   ENDIF

   OutStd( XML_ExpatVersion(), hb_eol() )
   XML_ExpatVersionInfo( @v1, @v2, @v3 )
   OutStd( v1, v2, v3, hb_eol() )
   hb_XML_ExpatVersionInfo( @v1, @v2, @v3 )
   OutStd( v1, v2, v3, hb_eol() )

   IF Empty( p )
      OutErr( "Couldn't allocate memory for parser", hb_eol() )
      ErrorLevel( -1 )
      RETURN
   ENDIF

   xData := Array( 1 )
   xData[ 1 ] := 1

   OutStd( XML_GetUserData( p ), hb_eol() )
   XML_SetUserData( p, xData )
   OutStd( ValType( XML_GetUserData( p ) ), hb_eol() )
   XML_SetElementHandler( p, {| x, e, a | start( x, e, a ) }, {| x, e | end( x, e ) } )
   XML_SetCharacterDataHandler( p, {| x, d | data( x, d ) } )

   IF XML_Parse( p, MemoRead( cFileName ), .T. ) == HB_XML_STATUS_ERROR
      OutErr( hb_StrFormat( e"Parse error at line %s:\n%s\n",;
                 hb_ntos( XML_GetCurrentLineNumber( p ) ),;
                 XML_ErrorString( XML_GetErrorCode( p ) ) ) )
      ErrorLevel( -1 )
      RETURN
   ENDIF

   RETURN

PROCEDURE start( xData, cElement, aAttr )
   LOCAL aItem

   OutStd( Replicate( "  ", xData[ 1 ] ), cElement )

   IF ! Empty( aAttr )
      FOR EACH aItem IN aAttr
         OutStd( " " + aItem[ HB_XML_ATTR_cName ] + "='" + aItem[ HB_XML_ATTR_cValue ] + "'" )
      NEXT
   ENDIF

   OutStd( hb_eol() )

   ++xData[ 1 ]

   RETURN

PROCEDURE end( xData, cElement )

   HB_SYMBOL_UNUSED( xData )
   HB_SYMBOL_UNUSED( cElement )

   --xData[ 1 ]

   RETURN

PROCEDURE data( xData, cData )

   HB_SYMBOL_UNUSED( xData )

   IF ! Empty( cData )
      OutStd( ">" + cData + "<" )
   ENDIF

   RETURN
