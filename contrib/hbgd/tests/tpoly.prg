/*
 * $Id: tpoly.prg 15856 2010-11-21 14:57:50Z vszakats $
 */

/*
 * Koch Flake -- for testing gdImage*Polygon()
 */

#include "gd.ch"
#include "simpleio.ch"

#command TurnRight( <x> ) => s_nAngle += Pi() / 3 * <x>
#command TurnLeft( <x> )  => s_nAngle -= Pi() / 3 * <x>

#define IMAGES_OUT "imgs_out" + hb_ps()

STATIC s_aCoords
STATIC s_nAngle, s_nCoordX, s_nCoordY

PROCEDURE Main()

   DrawFlake( .T. )
   DrawFlake( .F. )

   RETURN

PROCEDURE DrawFlake( lOpenPoly )

   LOCAL nOrder, nSide, nSides, nSideLen
   LOCAL gdImage, gdColor
   LOCAL cImageName

   nSides := 3
   nSideLen := 1500
   nOrder := 7

   cImageName := IIF( lOpenPoly, "flakeo.png", "flake.png" )

   gdImage := gdImageCreate( 1900, 2100 )
   gdImageColorAllocate( gdImage, 0, 0, 0 )

   /* Flake inside out, initial state */
   s_nCoordX := 200
   s_nCoordY := 600
   s_aCoords := { { s_nCoordX, s_nCoordY } }
   s_nAngle := 0

   FOR nSide := 1 TO nSides
      KochFlake( nOrder, nSideLen, .F. )
      s_nAngle += Pi() * 2 / nSides
   NEXT

   OutStd( hb_strFormat( "Drawing %d vertices%s", Len( s_aCoords ), hb_eol() ) )

   /** In green */
   gdColor := gdImageColorAllocate( gdImage, 0, 255, 0 )
   IIF( lOpenPoly,;
        gdImageOpenPolygon( gdImage, s_aCoords, gdColor ),;
        gdImagePolygon( gdImage, s_aCoords, gdColor ) )

   /* Regular flake, initial state */
   s_nCoordX := 200
   s_nCoordY := 600
   s_aCoords := { { s_nCoordX, s_nCoordY } }
   s_nAngle := 0

   FOR nSide := 1 TO nSides
      KochFlake( nOrder, nSideLen, .T. )
      s_nAngle += Pi() * 2 / nSides
   NEXT

   OutStd( hb_strFormat( "Drawing %d vertices%s", Len( s_aCoords ), hb_eol() ) )

   /** In yellow */
   gdColor := gdImageColorAllocate( gdImage, 255, 255, 0 )
   IIF( lOpenPoly,;
        gdImageOpenPolygon( gdImage, s_aCoords, gdColor ),;
        gdImagePolygon( gdImage, s_aCoords, gdColor ) )

   gdImagePng( gdImage, IMAGES_OUT + cImageName )
   gdImageDestroy( gdImage )

   RETURN

PROCEDURE KochFlake( nOrder, nSideLen, lLeftFirst )

   IF nOrder == 0
      AAdd( s_aCoords, {;
            s_nCoordX += Cos( s_nAngle ) * nSideLen,;
            s_nCoordY += Sin( s_nAngle ) * nSideLen;
      })
   ELSE
      KochFlake( nOrder - 1, nSideLen  / 3, lLeftFirst )

      IF lLeftFirst
         TurnLeft( 1 )
      ELSE
         TurnRight( 1 )
      ENDIF
      KochFlake( nOrder - 1, nSideLen  / 3, lLeftFirst )

      IF lLeftFirst
         TurnRight( 2 )
      ELSE
         TurnLeft( 2 )
      ENDIF
      KochFlake( nOrder - 1, nSideLen  / 3, lLeftFirst )

      IF lLeftFirst
         TurnLeft( 1 )
      ELSE
         TurnRight( 1 )
      ENDIF
      KochFlake( nOrder - 1, nSideLen  / 3, lLeftFirst )
   ENDIF

   RETURN
