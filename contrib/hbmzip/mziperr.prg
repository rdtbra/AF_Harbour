/*
 * $Id: mziperr.prg 16861 2011-06-06 19:20:22Z vszakats $
 */

/*
 * Harbour Project source code:
 * mzip error strings
 *
 * Copyright 2011 Viktor Szakats (harbour.01 syenar.hu)
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

#include "hbmzip.ch"

FUNCTION hb_ZipErrorStr( nStatus )

   DO CASE
   CASE nStatus == ZIP_OK                  ; RETURN "ZIP_OK"
   CASE nStatus == ZIP_EOF                 ; RETURN "ZIP_EOF"
   CASE nStatus == ZIP_ERRNO               ; RETURN "ZIP_ERRNO"
   CASE nStatus == ZIP_PARAMERROR          ; RETURN "ZIP_PARAMERROR"
   CASE nStatus == ZIP_BADZIPFILE          ; RETURN "ZIP_BADZIPFILE"
   CASE nStatus == ZIP_INTERNALERROR       ; RETURN "ZIP_INTERNALERROR"
   CASE nStatus == 1                       ; RETURN "Z_STREAM_END"
   CASE nStatus == 2                       ; RETURN "Z_NEED_DICT"
   CASE nStatus == -1                      ; RETURN "Z_ERRNO"
   CASE nStatus == -2                      ; RETURN "Z_STREAM_ERROR"
   CASE nStatus == -3                      ; RETURN "Z_DATA_ERROR"
   CASE nStatus == -4                      ; RETURN "Z_MEM_ERROR"
   CASE nStatus == -5                      ; RETURN "Z_BUF_ERROR"
   CASE nStatus == -6                      ; RETURN "Z_VERSION_ERROR"
   ENDCASE

   RETURN "ZIP_UNKNOWN: " + hb_ntos( nStatus )

FUNCTION hb_UnzipErrorStr( nStatus )

   DO CASE
   CASE nStatus == UNZ_OK                  ; RETURN "UNZ_OK"
   CASE nStatus == UNZ_END_OF_LIST_OF_FILE ; RETURN "UNZ_END_OF_LIST_OF_FILE"
   CASE nStatus == UNZ_ERRNO               ; RETURN "UNZ_ERRNO"
   CASE nStatus == UNZ_EOF                 ; RETURN "UNZ_EOF"
   CASE nStatus == UNZ_PARAMERROR          ; RETURN "UNZ_PARAMERROR"
   CASE nStatus == UNZ_BADZIPFILE          ; RETURN "UNZ_BADZIPFILE"
   CASE nStatus == UNZ_INTERNALERROR       ; RETURN "UNZ_INTERNALERROR"
   CASE nStatus == UNZ_CRCERROR            ; RETURN "UNZ_CRCERROR"
   CASE nStatus == 1                       ; RETURN "Z_STREAM_END"
   CASE nStatus == 2                       ; RETURN "Z_NEED_DICT"
   CASE nStatus == -1                      ; RETURN "Z_ERRNO"
   CASE nStatus == -2                      ; RETURN "Z_STREAM_ERROR"
   CASE nStatus == -3                      ; RETURN "Z_DATA_ERROR"
   CASE nStatus == -4                      ; RETURN "Z_MEM_ERROR"
   CASE nStatus == -5                      ; RETURN "Z_BUF_ERROR"
   CASE nStatus == -6                      ; RETURN "Z_VERSION_ERROR"
   ENDCASE

   RETURN "UNZ_UNKNOWN: " + hb_ntos( nStatus )
