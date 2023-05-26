/*
 * $Id: hbwinuni.h 14673 2010-06-03 14:48:23Z vszakats $
 */

/*
 * Harbour Project source code:
 * Windows UNICODE helper macros
 *
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
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

#ifndef HB_WINUNI_H_
#define HB_WINUNI_H_

#include "hbapistr.h"

#if defined( HB_OS_WIN )

#include "hbset.h"

#if defined( UNICODE )
   #define HB_PARSTR( n, h, len )                hb_parstr_u16( n, HB_CDP_ENDIAN_NATIVE, h, len )
   #define HB_PARSTRDEF( n, h, len )             hb_wstrnull( hb_parstr_u16( n, HB_CDP_ENDIAN_NATIVE, h, len ) )
   #define HB_RETSTR( str )                      hb_retstr_u16( HB_CDP_ENDIAN_NATIVE, str )
   #define HB_RETSTRLEN( str, len )              hb_retstrlen_u16( HB_CDP_ENDIAN_NATIVE, str, len )
   #define HB_STORSTR( str, n )                  hb_storstr_u16( HB_CDP_ENDIAN_NATIVE, str, n )
   #define HB_STORSTRLEN( str, len, n )          hb_storstrlen_u16( HB_CDP_ENDIAN_NATIVE, str, len, n )
   #define HB_ARRAYGETSTR( arr, n, phstr, plen ) hb_arrayGetStrU16( arr, n, HB_CDP_ENDIAN_NATIVE, phstr, plen )
   #define HB_ARRAYSETSTR( arr, n, str )         hb_arraySetStrU16( arr, n, HB_CDP_ENDIAN_NATIVE, str )
   #define HB_ARRAYSETSTRLEN( arr, n, str, len ) hb_arraySetStrLenU16( arr, n, HB_CDP_ENDIAN_NATIVE, str, len )
   #define HB_ITEMCOPYSTR( itm, str, len )       hb_itemCopyStrU16( itm, HB_CDP_ENDIAN_NATIVE, str, len )
   #define HB_ITEMGETSTR( itm, phstr, plen )     hb_itemGetStrU16( itm, HB_CDP_ENDIAN_NATIVE, phstr, plen )
   #define HB_ITEMPUTSTR( itm, str )             hb_itemPutStrU16( itm, HB_CDP_ENDIAN_NATIVE, str )
   #define HB_ITEMPUTSTRLEN( itm, str, len )     hb_itemPutStrLenU16( itm, HB_CDP_ENDIAN_NATIVE, str, len )
   #define HB_STRUNSHARE( h, str, len )          hb_wstrunshare( h, str, len )
#else
   #define HB_PARSTR( n, h, len )                hb_parstr( n, hb_setGetOSCP(), h, len )
   #define HB_PARSTRDEF( n, h, len )             hb_strnull( hb_parstr( n, hb_setGetOSCP(), h, len ) )
   #define HB_RETSTR( str )                      hb_retstr( hb_setGetOSCP(), str )
   #define HB_RETSTRLEN( str, len )              hb_retstrlen( hb_setGetOSCP(), str, len )
   #define HB_STORSTR( str, n )                  hb_storstr( hb_setGetOSCP(), str, n )
   #define HB_STORSTRLEN( str, len, n )          hb_storstrlen( hb_setGetOSCP(), str, len, n )
   #define HB_ARRAYGETSTR( arr, n, phstr, plen ) hb_arrayGetStr( arr, n, hb_setGetOSCP(), phstr, plen )
   #define HB_ARRAYSETSTR( arr, n, str )         hb_arraySetStr( arr, n, hb_setGetOSCP(), str )
   #define HB_ARRAYSETSTRLEN( arr, n, str, len ) hb_arraySetStrLen( arr, n, hb_setGetOSCP(), str, len )
   #define HB_ITEMCOPYSTR( itm, str, len )       hb_itemCopyStr( itm, hb_setGetOSCP(), str, len )
   #define HB_ITEMGETSTR( itm, phstr, plen )     hb_itemGetStr( itm, hb_setGetOSCP(), phstr, plen )
   #define HB_ITEMPUTSTR( itm, str )             hb_itemPutStr( itm, hb_setGetOSCP(), str )
   #define HB_ITEMPUTSTRLEN( itm, str, len )     hb_itemPutStrLen( itm, hb_setGetOSCP(), str, len )
   #define HB_STRUNSHARE( h, str, len )          hb_strunshare( h, str, len )
#endif

#endif /* HB_OS_WIN */

#endif /* HB_WINUNI_H_ */
