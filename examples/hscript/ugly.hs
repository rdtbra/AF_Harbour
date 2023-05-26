<% FUNCTION Start()
/*
 * $Id: ugly.hs 14676 2010-06-03 16:23:36Z vszakats $
 */

/* Written by Felipe Coury <fcoury@flexsys-ci.com>
* www - http://harbour-project.org
*
*/

      LOCAL a := "Hello Mom!" %><HTML><BODY><%
      OutStd( a ) %><P>This is a <B>very ugly</B> script!!!<%
      OutStd( "Line 2" )
      %>
<P>
<%
OutStd( a, a, a )
%>
</HTML><%RETURN NIL%>
