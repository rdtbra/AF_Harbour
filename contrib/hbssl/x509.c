/*
 * $Id: x509.c 16474 2011-03-14 15:18:11Z vszakats $
 */

/*
 * Harbour Project source code:
 * OpenSSL API (X509) - Harbour interface.
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

#include "hbapi.h"
#include "hbapierr.h"

#if defined( HB_OS_WIN )
#  include <windows.h>
#  include <wincrypt.h>
#endif

#include "hbssl.h"

static HB_GARBAGE_FUNC( X509_release )
{
   void ** ph = ( void ** ) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( ph && * ph )
   {
      /* Destroy the object */
      X509_free( ( X509 * ) * ph );

      /* set pointer to NULL just in case */
      * ph = NULL;
   }
}

static const HB_GC_FUNCS s_gcX509_funcs =
{
   X509_release,
   hb_gcDummyMark
};

void * hb_X509_is( int iParam )
{
   return hb_parptrGC( &s_gcX509_funcs, iParam );
}

X509 * hb_X509_par( int iParam )
{
   void ** ph = ( void ** ) hb_parptrGC( &s_gcX509_funcs, iParam );

   return ph ? ( X509 * ) * ph : NULL;
}

void hb_X509_ret( X509 * x509 )
{
   void ** ph = ( void ** ) hb_gcAllocate( sizeof( X509 * ), &s_gcX509_funcs );

   * ph = ( void * ) x509;

   hb_retptrGC( ph );
}

HB_FUNC( X509_GET_SUBJECT_NAME )
{
   if( hb_X509_is( 1 ) )
   {
      X509 * x509 = hb_X509_par( 1 );

      if( x509 )
         hb_retptr( X509_get_subject_name( x509 ) );
   }
   else
      hb_errRT_BASE( EG_ARG, 2010, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

HB_FUNC( X509_GET_ISSUER_NAME )
{
   if( hb_X509_is( 1 ) )
   {
      X509 * x509 = hb_X509_par( 1 );

      if( x509 )
         hb_retptr( X509_get_issuer_name( x509 ) );
   }
   else
      hb_errRT_BASE( EG_ARG, 2010, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

HB_FUNC( X509_NAME_ONELINE )
{
#if OPENSSL_VERSION_NUMBER < 0x10000000L || OPENSSL_VERSION_NUMBER >= 0x1000000FL /* NOTE: Compilation error when tried with 1.0.0beta5 */
   X509_NAME * x509_name = ( X509_NAME * ) hb_parptr( 1 );

   if( x509_name )
   {
      char buffer[ 1024 ];
      X509_NAME_oneline( x509_name, buffer, sizeof( buffer ) );
      hb_retc( buffer );
   }
   else
      hb_errRT_BASE( EG_ARG, 2010, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
#endif
}
