/*
 * $Id: langapi.prg 11201 2009-06-03 10:26:40Z vszakats $
 */

// ; Donated to the public domain by
//   Viktor Szakats (harbour.01 syenar.hu)

REQUEST HB_LANG_HU852
REQUEST HB_LANG_KO

func main()

? "Prev:", hb_langselect()
? hb_langName()
? NationMsg( 1 )
? CMonth( Date() )
? CDOW( Date() )
? "---------"

? "Prev:", hb_langSelect( "HU852" )
? hb_langName()
? NationMsg( 1 )
? CMonth( Date() )
? CDOW( Date() )
? "---------"

? "Prev:", hb_langSelect( "NOTHERE" )
? hb_langName()
? NationMsg( 1 )
? CMonth( Date() )
? CDOW( Date() )
? "---------"

? "Prev:", hb_langSelect( "KO" )
? hb_langName()
? NationMsg( 1 )
? CMonth( Date() )
? CDOW( Date() )
? "---------"

return nil

