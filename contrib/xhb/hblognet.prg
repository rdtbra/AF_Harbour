/*
 * $Id: hblognet.prg 14746 2010-06-12 12:15:59Z vszakats $
 */

/*
 * xHarbour Project source code:
 * Versatile logging system - Logger sending log message to e-mail
 *
 * Copyright 2003 Giancarlo Niccolai [gian@niccolai.ws]
 * www - http://www.xharbour.org
 *
 * this program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * this program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE.  See the
 * GNU General public License for more details.
 *
 * You should have received a copy of the GNU General public License
 * along with this software; see the file COPYING.  if not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, xHarbour license gives permission for
 * additional uses of the text contained in its release of xHarbour.
 *
 * The exception is that, if you link the xHarbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General public License.
 * Your use of that executable is in no way restricted on account of
 * linking the xHarbour library code into it.
 *
 * this exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General public License.
 *
 * this exception applies only to the code released with this xHarbour
 * explicit exception.  if you add/copy code from other sources,
 * as the General public License permits, the above exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * if you write modifications of your own for xHarbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * if you do not wish that, delete this exception notice.
 *
 */

#include "hbclass.ch"
#include "common.ch"

#define HB_THREAD_SUPPORT

CLASS HB_LogEmail FROM HB_LogChannel
   DATA cServer
   DATA cAddress        INIT "log@xharbour.org"
   DATA cSubject        INIT "Log message from xharbour application"
   DATA cSendTo
   DATA cHelo           INIT "XHarbour E-mail Logger"
   DATA nPort           INIT 25

   DATA cPrefix
   DATA cPostfix

   METHOD New( nLevel, cHelo, cServer, cSendTo, cSubject, cFrom )
   METHOD Open( cName )
   METHOD Close( cName )

PROTECTED:
   METHOD Send( nStyle, cMessage, cName, nPriority )

HIDDEN:
   METHOD GetOk( skCon )
   METHOD Prepare( nStyle, cMessage, cName, nPriority )

ENDCLASS

METHOD New(  nLevel, cHelo, cServer, cSendTo, cSubject, cFrom ) CLASS HB_LogEmail
   LOCAL nPos

   ::Super:New( nLevel )

   nPos := At( ":", cServer )
   IF nPos > 0
      ::nPort := Val(Substr( cServer, nPos + 1 ) )
      cServer := Substr( cServer , 1, nPos -1 )
   ENDIF

   ::cServer := cServer
   ::cSendTo := cSendTo

   IF cHelo != NIL
      ::cHelo := cHelo
   ENDIF

   IF cSubject != NIL
      ::cSubject := cSubject
   ENDIF

   IF cFrom != NIL
      ::cAddress := cFrom
   ENDIF

RETURN SELF

/**
* Inet init must be called here
*/
METHOD Open( cName ) CLASS HB_LogEmail
   HB_SYMBOL_UNUSED( cName )
   hb_inetInit()
RETURN .T.

/**
* InetCleanup to be called here
*/
METHOD Close( cName ) CLASS HB_LogEmail
   HB_SYMBOL_UNUSED( cName )
   hb_inetCleanup()
RETURN .T.


/**
* Sends the real message in e-mail
*/

METHOD Send( nStyle, cMessage, cName, nPriority ) CLASS HB_LogEmail
   LOCAL skCon := hb_inetCreate()


   hb_inetTimeout( skCon, 10000 )

   hb_inetConnect( ::cServer, ::nPort, skCon )

   IF hb_inetErrorCode( skCon ) != 0 .or. ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   hb_inetSendAll( skCon, "HELO " + ::cHelo + hb_inetCRLF() )
   IF ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   hb_inetSendAll( skCon, "MAIL FROM: <" + ::cAddress +">" + hb_inetCRLF() )
   IF ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   hb_inetSendAll( skCon, "RCPT TO: <" + ::cSendTo +">" + hb_inetCRLF() )
   IF ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   hb_inetSendAll( skCon, "DATA" + hb_inetCRLF() )
   IF ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   cMessage := ::Prepare( nStyle, cMessage, cName, nPriority )

   hb_inetSendAll( skCon,  cMessage + hb_inetCRLF() + "." + hb_inetCRLF() )
   IF ! ::GetOk( skCon )
      RETURN .F.
   ENDIF

   hb_inetSendAll( skCon, "QUIT" + hb_inetCRLF() )

RETURN ::GetOk( skCon )  // if quit fails, the mail does not go!

/**
* Get the reply and returns true if it is allright
*/

METHOD GetOk( skCon ) CLASS HB_LogEmail
   LOCAL nLen, cReply

   cReply := hb_inetRecvLine( skCon, @nLen, 128 )
   IF hb_inetErrorCode( skcon ) != 0 .or. Substr( cReply, 1, 1 ) == '5'
      RETURN .F.
   ENDIF
RETURN .T.

METHOD Prepare( nStyle, cMessage, cName, nPriority ) CLASS HB_LogEmail
   LOCAL cPre
   cPre := "FROM: " + ::cAddress + hb_inetCRLF() + ;
               "TO: " + ::cSendTo + hb_inetCRLF() +;
               "Subject:" + ::cSubject + hb_inetCRLF() + hb_inetCRLF()

   IF ! Empty( ::cPrefix )
      cPre += ::cPrefix + hb_inetCRLF() + hb_inetCRLF()
   ENDIF

   cPre += ::Format( nStyle, cMessage, cName, nPriority )

   IF ! Empty( ::cPostfix )
      cPre += hb_inetCRLF() +hb_inetCRLF() + ::cPostfix + hb_inetCRLF()
   ENDIF

RETURN cPre



/************************************************
* Channel for monitors listening on a port
*************************************************/

CLASS HB_LogInetPort FROM HB_LogChannel
   DATA nPort           INIT 7761
   DATA aListeners      INIT {}
   DATA skIn

#ifdef HB_THREAD_SUPPORT
   DATA bTerminate      INIT .F.
   DATA nThread
   DATA mtxBusy
#endif

   METHOD New( nLevel, nPort )
   METHOD Open( cName )
   METHOD Close( cName )

PROTECTED:
   METHOD Send( nStyle, cMessage, cName, nPriority )

#ifdef HB_THREAD_SUPPORT
HIDDEN:
   METHOD AcceptCon()
#endif

ENDCLASS


METHOD New( nLevel, nPort ) CLASS HB_LogInetPort

   ::Super:New( nLevel )

   IF nPort != NIL
      ::nPort := nPort
   ENDIF

RETURN Self


METHOD Open( cName ) CLASS HB_LogInetPort

   HB_SYMBOL_UNUSED( cName )

   hb_inetInit()

   ::skIn := hb_inetServer( ::nPort )

   IF ::skIn == NIL
      RETURN .F.
   ENDIF

#ifdef HB_THREAD_SUPPORT
   ::mtxBusy := HB_MutexCreate()
   ::nThread := HB_ThreadStart( Self, "AcceptCon" )
#else
   // If we have not threads, we have to sync accept incoming connection
   // when we log a message
   hb_inetTimeout( ::skIn, 50 )
#endif

RETURN .T.


METHOD Close( cName ) CLASS HB_LogInetPort
   LOCAL sk

   HB_SYMBOL_UNUSED( cName )

   IF ::skIn == NIL
      RETURN .F.
   ENDIF

#ifdef HB_THREAD_SUPPORT
   // kind termination request
   ::bTerminate := .T.
   hb_ThreadJoin( ::nThread )
#endif

   hb_inetClose( ::skIn )

   // we now are sure that incoming thread index is not used.

   DO WHILE  Len( ::aListeners ) > 0
      sk := ATail( ::aListeners )
      ASize( ::aListeners, Len( ::aListeners ) - 1 )
      hb_inetClose( sk )
   ENDDO

   hb_inetCleanup()
RETURN .T.


METHOD Send( nStyle, cMessage, cName, nPriority ) CLASS HB_LogInetPort
   LOCAL sk, nCount

#ifdef HB_THREAD_SUPPORT
   // be sure thread is not busy now
   HB_MutexLock( ::mtxBusy )
#else
   // IF we have not a thread, we must see if there is a new connection
   sk := hb_inetAccept( ::skIn )  //timeout should be short

   IF sk != NIL
      Aadd( ::aListeners, sk )
   ENDIF
#endif

   // now we transmit the message to all the available channels
   cMessage := ::Format( nStyle, cMessage, cName, nPriority )

   nCount := 1
   DO WHILE nCount <= Len( ::aListeners )
      sk := ::aListeners[ nCount ]
      hb_inetSendAll( sk, cMessage + hb_inetCRLF() )
      // if there is an error, we remove the listener
      IF hb_inetErrorCode( sk ) != 0
         ADel( ::aListeners, nCount )
         ASize( ::aListeners , Len( ::aListeners ) - 1)
      ELSE
         nCount ++
      ENDIF
   ENDDO

#ifdef HB_THREAD_SUPPORT
   HB_MutexUnlock( ::mtxBusy )
#endif

RETURN .T.


#ifdef HB_THREAD_SUPPORT
METHOD AcceptCon() CLASS HB_LogInetPort
   LOCAL sk

   hb_inetTimeout( ::skIn, 250 )
   DO WHILE ! ::bTerminate
      sk := hb_inetAccept( ::skIn )
      // A gentle termination request, or an error
      IF sk != NIL
         HB_MutexLock( ::mtxBusy )
         AAdd( ::aListeners, sk )
         HB_MutexUnlock( ::mtxBusy )
      ENDIF
   ENDDO
RETURN .T.

#endif
