/*
 * $Id: testhbf.prg 15174 2010-07-25 08:45:50Z vszakats $
 */

/*
test program for hb_f*()
harbour clones for nanfor's ft_f*()
inplementation of :
  * hb_fuse()
  * hb_fskip()
  * hb_feof()
  * hb_frecno()
  * hb_freadln()
  * hb_flastrec()
  * hb_fgoto()
  * hb_fgotop()
  * hb_fgobottom()
*/

PROCEDURE Main()

   // open a text file here
   IF hb_fuse( "testhbf.prg", 0 ) > 1

      DO WHILE ! hb_feof()
         qout( "line " + str( hb_frecno(), 2 ) + " " + hb_freadln() )
         hb_fskip( 1 )
      ENDDO
      qout( "" )
      my_goto( 18 )
      my_goto( 2 )

      hb_fgobottom()
      qout( "" )
      qout( "after hb_fgobottom() now in line # " + hb_ntos( hb_frecno() ) )

      hb_fgotop()
      qout( "" )
      qout( "after hb_fgotop() now in line # " + hb_ntos( hb_frecno() ) )

      qout( "" )
      qout( "hb_flastrec() = " + hb_ntos( hb_flastrec() ) )

      // close the file
      hb_fuse()
   ENDIF

   RETURN

STATIC PROCEDURE my_goto( n_go )

   hb_fgoto( n_go )
   qout( "" )
   qout( "after hb_fgoto("+ hb_ntos( n_go ) + ")" )
   qout( "line "+ hb_ntos( hb_frecno() ) + " is " + ltrim( hb_freadln() ) )

   RETURN
