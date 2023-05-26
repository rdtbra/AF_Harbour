'
' $Id: oletst2.vbs 15569 2010-10-01 14:17:38Z snaiperis $
'

' Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
' www - http://harbour-project.org
'
' See COPYING for licensing terms.

Dim tst2 : Set tst2 = WScript.CreateObject("MyOleTimeServer")

WScript.CreateObject("Wscript.Shell").Popup tst2.Time()
