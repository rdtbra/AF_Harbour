/*
 * $Id: aemaxlen.prg 16754 2011-05-11 16:05:43Z vszakats $
 */

/*
 * File......: aemaxlen.prg
 * Author....: Ralph Oliver,  TRANSCOM SYSTEMS
 * CIS ID....: 74030,703
 *
 * This is an original work by Ralph Oliver and is placed in the
 * public domain.
 *
 * Modification history:
 * ---------------------
 *
 *    Rev 1.1   15 Aug 1991 23:05:38   GLENN
 * Forest Belt proofread/edited/cleaned up doc
 *
 *    Rev 1.0   07 Jun 1991 23:03:12   GLENN
 * Initial revision.
 *
 *
 */

#ifdef FT_TEST

FUNCTION MAIN()
   LOCAL var0, myarray1 := DIRECTORY()
   CLS
   ? "TEST TO DEMONSTRATE EXAMPLES OF FT_AEMAXLEN"
   ?
   ? "myarray1 := DIRECTORY()"
   ?
   var0 := FT_AEMAXLEN( myarray1 )
   ? PADR('FT_AEMAXLEN( myarray1 ) ->',30)
   ?? var0
   ?
   var0 := FT_AEMAXLEN( myarray1,2 )
   ? PADR('FT_AEMAXLEN( myarray1,2 ) ->',30)
   ?? var0
   ?
   var0 := FT_AEMAXLEN( myarray1,3 )
   ? PADR('FT_AEMAXLEN( myarray1,3 ) ->',30)
   ?? var0
   ?
   var0 := FT_AEMAXLEN( aTail( myarray1 ) )
   ? PADR('FT_AEMAXLEN( aTail( myarray1 ) ) ->',30)
   ?? var0
   ?
   RETURN NIL

#endif

FUNCTION FT_AEmaxlen( aArray, nDimension, nStart, nCount )

   LOCAL i, nLast, cType, nMaxlen := 0

   // Set default parameters as necessary.
   IF nDimension == NIL
      nDimension := 1
   ENDIF

   IF nStart == NIL
      nStart := 1
   ENDIF

   IF nCount == NIL
      nCount := LEN( aArray ) - nStart + 1
   ENDIF

   nLast := MIN( nStart +nCount -1, LEN( aArray ))

   FOR i := nStart TO nLast
      cType := VALTYPE( aArray[i] )
      DO CASE
         CASE ( cType == "C" )
            nMaxlen := MAX( nMaxlen, LEN( aArray[i] ))

         CASE ( cType == "A" )
            nMaxlen := MAX( nMaxlen, ;
               LEN( LTRIM( TRANSFORM( aArray[i] [nDimension], "@X"))))

         OTHERWISE
            nMaxlen := MAX( nMaxlen, ;
               LEN( LTRIM( TRANSFORM( aArray[i], "@X" ))))
      ENDCASE
   NEXT

   RETURN nMaxlen
