/*
 * $Id: oletst4.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test client code for OLE server returning to client
 *    HVM objects as OLE object. It's also test for parameters
 *    passed by reference.
 *
 * Copyright 2010 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 */

PROCEDURE Main()
   LOCAL oObject, oTime, oInfo
   LOCAL p1, p2, p3, p4, p5, p6, p7

   oObject := win_OleCreateObject( "MyOleObjServer" )

   IF !Empty( oObject )
      oTime := oObject:timer()
      ? "TIMER:"
      ? "      date:", oTime:date
      ? "      time:", oTime:time
      ? "       now:", oTime:now
      oInfo := oObject:info()
      ? "INFO:"
      ? "        os:", oInfo:os
      ? "       ver:", oInfo:ver
      ? "  compiler:", oInfo:compiler
      ? "     build:", oInfo:build
      ?
      ? "REF:", oObject:ref( @p1, @p2, @p3, @p4, @p5, @p6, @p7 )
      ? "        p1:", hb_valToExp( p1 )
      ? "        p2:", hb_valToExp( p2 )
      ? "        p3:", hb_valToExp( p3 )
      ? "        p4:", hb_valToExp( p4 )
      ? "        p5:", p5:className() // hb_valToExp( p5 )
      ? "        p6:", hb_valToExp( p6 )
      ? "        p7:", hb_valToExp( p7 )
   ELSE
      ? "Can not access 'MyOleObjServer' OLE server."
   ENDIF

   WAIT
RETURN
