/*
 * $Id: encode.prg 16200 2011-02-04 00:45:00Z vszakats $
 */

/*
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 */

#include "simpleio.ch"

#include "hbssl.ch"

PROCEDURE Main()

   LOCAL ctx
   LOCAL result
   LOCAL encrypted
   LOCAL decrypted

   SSL_INIT()

   OpenSSL_add_all_ciphers()

   ctx := hb_EVP_ENCODE_CTX_create()

   EVP_EncodeInit( ctx )

   encrypted := ""
   result := ""
   EVP_EncodeUpdate( ctx, @result, "sample text" )
   encrypted += result
   EVP_EncodeFinal( ctx, @result )
   encrypted += result
   ? "ENCRYTPTED", ">" + encrypted + "<"

   ctx := hb_EVP_ENCODE_CTX_create()

   EVP_DecodeInit( ctx )

   decrypted := ""
   result := ""
   EVP_DecodeUpdate( ctx, @result, encrypted )
   decrypted += result
   EVP_DecodeFinal( ctx, @result )
   decrypted += result
   ? "DECRYTPTED", ">" + decrypted + "<"

   RETURN
