/*
 * $Id: charlist.c 15102 2010-07-14 12:48:39Z vszakats $
 */

/*
 * Harbour Project source code:
 *   CT3 string functions
 *     - CHARLIST()
 *     - CHARNOLIST()
 *
 * Copyright 2001 IntTec GmbH, Neunlindenstr 32, 79106 Freiburg, Germany
 *        Author: Martin Vogel <vogel@inttec.de>
 *
 * www - http://harbour-project.org
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

#include "ct.h"

/* helper function for the list function */
void ct_charlist( int iMode )
{
   const char * pcString = hb_parcx( 1 );
   HB_SIZE sStrLen = hb_parclen( 1 );

   HB_SIZE asCharCnt[ 256 ];
   HB_SIZE sCnt;

   /* init asCharCnt */
   for( sCnt = 0; sCnt < HB_SIZEOFARRAY( asCharCnt ); ++sCnt )
      asCharCnt[ sCnt ] = 0;

   /* count characters */
   if( iMode == CT_CHARLIST_CHARLIST )
   {
      char pcRet[ 256 ];
      HB_SIZE sRetStrLen = 0;

      for( sCnt = 0; sCnt < sStrLen; ++sCnt )
      {
         if( asCharCnt[ ( HB_UCHAR ) pcString[ sCnt ] ] == 0 )
         {
            pcRet[ sRetStrLen++ ] = pcString[ sCnt ];
            asCharCnt[ ( HB_UCHAR ) pcString[ sCnt ] ] = 1;
         }
      }
      hb_retclen( pcRet, sRetStrLen );
   }
   else
   {
      for( sCnt = 0; sCnt < sStrLen; ++sCnt )
         asCharCnt[ ( HB_UCHAR ) pcString[ sCnt ] ]++;

      switch( iMode )
      {
         case CT_CHARLIST_CHARSLIST:
         {
            char * pcRet = ( char * ) hb_xgrab( HB_SIZEOFARRAY( asCharCnt ) );
            HB_SIZE sRetStrLen = 0;

            for( sCnt = 0; sCnt < HB_SIZEOFARRAY( asCharCnt ); ++sCnt )
            {
               if( asCharCnt[ sCnt ] != 0 )
                  pcRet[ sRetStrLen++ ] = ( HB_UCHAR ) sCnt;
            }

            hb_retclen_buffer( pcRet, sRetStrLen );
            break;
         }
         case CT_CHARLIST_CHARNOLIST:
         {
            char * pcRet = ( char * ) hb_xgrab( HB_SIZEOFARRAY( asCharCnt ) );
            HB_SIZE sRetStrLen = 0;

            for( sCnt = 0; sCnt < HB_SIZEOFARRAY( asCharCnt ); ++sCnt )
            {
               if( asCharCnt[ sCnt ] == 0 )
                  pcRet[ sRetStrLen++ ] = ( HB_UCHAR ) sCnt;
            }

            hb_retclen_buffer( pcRet, sRetStrLen );
            break;
         }
         case CT_CHARLIST_CHARHIST:
         {
            PHB_ITEM pArray = hb_itemArrayNew( HB_SIZEOFARRAY( asCharCnt ) );

            for( sCnt = 0; sCnt < HB_SIZEOFARRAY( asCharCnt ); ++sCnt )
               hb_arraySetNS( pArray, sCnt + 1, asCharCnt[ sCnt ] );

            hb_itemReturnRelease( pArray );
            break;
         }
      }
   }
}

HB_FUNC( CHARLIST )
{
   ct_charlist( CT_CHARLIST_CHARLIST );
}

HB_FUNC( CHARNOLIST )
{
   ct_charlist( CT_CHARLIST_CHARNOLIST );
}
