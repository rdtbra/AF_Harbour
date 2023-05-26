/*
 * $Id: testmapi.prg 16841 2011-06-02 09:02:44Z vszakats $
 */

#include "simpleio.ch"

#include "hbwin.ch"

PROCEDURE Main()

   LOCAL cSubject := "Test subject"
   LOCAL cBody := "Test body"
   LOCAL lMailConf := .F.
   LOCAL lFromUser := .T.
   LOCAL aSender := { "test from", "from@test.com" }
   LOCAL aDest := { { "test to", "to@test.com", WIN_MAPI_TO } }
   LOCAL aFiles := { { "testmapi.prg", "testmapi" } }

   ? win_MAPISendMail( cSubject,                        ; // subject
                       cBody,                           ; // menssage
                       NIL,                             ; // type of message
                       DToS( Date() ) + " " + Time(),   ; // send date
                       "",                              ; // conversation ID
                       lMailConf,                       ; // acknowledgment
                       lFromUser,                       ; // user intervention
                       aSender,                         ; // sender
                       aDest,                           ; // destinators
                       aFiles                           ; // attach
                     )

   // simple format

   ? win_MAPISendMail( cSubject,                        ; // subject
                       cBody,                           ; // menssage
                       NIL,                             ; // type of message
                       DToS( Date() ) + " " + Time(),   ; // send date
                       "",                              ; // conversation ID
                       lMailConf,                       ; // acknowledgment
                       lFromUser,                       ; // user intervention
                       "from@test.com",                 ; // sender
                       { "to@test.com" },               ; // destinators
                       { "testmapi.prg" }               ; // attach
                     )

   RETURN
