/*
 * $Id: gmail.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 */

#include "common.ch"
#include "simpleio.ch"

PROCEDURE Main( cFrom, cPassword, cTo )

   DEFAULT cFrom     TO "<myname@gmail.com>"
   DEFAULT cPassword TO "<mypassword>"
   DEFAULT cTo       TO "addressee@domain.com"

   ? hb_SendMail( "smtp.gmail.com",;
                  465,;
                  cFrom,;
                  cTo,;
                  NIL /* CC */,;
                  {} /* BCC */,;
                  "test: body",;
                  "test: subject",;
                  NIL /* attachment */,;
                  cFrom,;
                  cPassword,;
                  "",;
                  NIL /* nPriority */,;
                  NIL /* lRead */,;
                  .T. /* lTrace */,;
                  .F.,;
                  NIL /* lNoAuth */,;
                  NIL /* nTimeOut */,;
                  NIL /* cReplyTo */,;
                  .T. )

   RETURN
