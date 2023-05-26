/*
 * $Id: testenv.prg 9243 2008-08-25 21:36:00Z vszakats $
 */

#include "common.ch"

function Test( cParam )

   LOCAL cFile := "C:\harbour\bin\harbour.exe"

   DEFAULT cParam TO cFile

   ? FilePath( cParam )
   ? FileBase( cParam )
   ? FileExt( cParam )
   ? FileDrive( cParam )

return nil
