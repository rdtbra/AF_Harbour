/*
 * $Id: cttime.prg 14578 2010-05-25 07:26:37Z vszakats $
 */

/*
 * xHarbour Project source code:
 * TIMETOSEC(), SECTOTIME(), MILLISEC()
 *
 * Copyright 2003 Piero Vincenzo Lupano <pierovincenzo1956@supereva.it>
 * Copyright 2003 Przemyslaw Czerpak <druzus@acn.waw.pl>
 * www - http://www.xharbour.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "common.ch"

FUNCTION TIMETOSEC( cTime )
   LOCAL nSec := 0
   LOCAL nLen, i, aLim, aMod, nInd, n

   IF cTime == NIL
      nSec := Seconds()
   ELSEIF ISCHARACTER( cTime )
      nLen := Len( cTime )
      IF ( nLen + 1 ) % 3 == 0 .AND. nLen <= 11
         nInd := 1
         aLim := { 24, 60, 60, 100 }
         aMod := { 3600, 60, 1, 1 / 100 }
         FOR i := 1 TO nLen STEP 3
            IF IsDigit( SubStr( cTime, i,     1 ) ) .AND. ;
               IsDigit( SubStr( cTime, i + 1, 1 ) ) .AND. ;
               ( i == nLen - 1 .OR. SubStr( cTime, i + 2, 1 ) == ":" ) .AND. ;
               ( n := Val( SubStr( cTime, i, 2 ) ) ) < aLim[ nInd ]
               nSec += n * aMod[ nInd ]
            ELSE
               nSec := 0
               EXIT
            ENDIF
            ++nInd
         NEXT
      ENDIF
   ENDIF

   RETURN Round( nSec, 2 ) /* round FL val to be sure that you can compare it */

FUNCTION SECTOTIME( nSec, lHundr )
   LOCAL i, h, n

   n := iif( ! ISNUMBER( nSec ), Seconds(), nSec )

   IF ISLOGICAL( lHundr ) .AND. lHundr
      h := ":" + StrZero( ( nSec * 100 ) % 100, 2 )
   ELSE
      h := ""
   ENDIF

   n := Int( n % 86400 )

   FOR i := 1 TO 3
      h := StrZero( n % 60, 2 ) + iif( Len( h ) == 0, "", ":" ) + h
      n := Int( n / 60 )
   NEXT

   RETURN h

FUNCTION MILLISEC( nDelay )
   HB_IDLESLEEP( nDelay / 1000 )
   RETURN ""
