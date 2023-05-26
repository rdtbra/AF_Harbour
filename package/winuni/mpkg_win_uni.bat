@rem
@rem $Id: mpkg_win_uni.bat 16946 2011-07-17 13:10:57Z vszakats $
@rem

@echo off

rem ---------------------------------------------------------------
rem Copyright 2009-2011 Viktor Szakats (harbour.01 syenar.hu)
rem See COPYING for licensing terms.
rem ---------------------------------------------------------------

rem - Adjust target dir, mingw dirs, set HB_DIR_UPX, HB_DIR_7Z, HB_DIR_MINGW, HB_DIR_UNICOWS,
rem   create required packages beforehand.
rem - Requires BCC in PATH or HB_DIR_BCC_IMPLIB (for implib).
rem - Run this from vanilla official source tree only.

echo ! Self: %0

if "%HB_VS%" == "" set HB_VS=30
if "%HB_VL%" == "" set HB_VL=300
if "%HB_VM%" == "" set HB_VM=3.0
if "%HB_VF%" == "" set HB_VF=3.0.0
if "%HB_RT%" == "" set HB_RT=C:\hb\

set HB_DR=hb%HB_VS%\
set HB_ABSROOT=%HB_RT%%HB_DR%

rem ; Assemble unified package from per-target builds

if exist %HB_ABSROOT% rd /q /s %HB_ABSROOT%

xcopy /y       %~dp0RELNOTES                                                              %HB_ABSROOT%
xcopy /y /s    %~dp0..\..\examples\*.*                                                    %HB_ABSROOT%examples\
xcopy /y /s    %~dp0..\..\tests\*.*                                                       %HB_ABSROOT%tests\
xcopy /y       %~dp0HARBOUR_README_ADDONS                                                 %HB_ABSROOT%addons\
xcopy /y       %~dp0HARBOUR_README_DJGPP                                                  %HB_ABSROOT%comp\djgpp\
xcopy /y       %~dp0HARBOUR_README_MINGW                                                  %HB_ABSROOT%comp\mingw\
xcopy /y       %~dp0HARBOUR_README_MINGW64                                                %HB_ABSROOT%comp\mingw64\
xcopy /y       %~dp0HARBOUR_README_MINGWARM                                               %HB_ABSROOT%comp\mingwarm\
xcopy /y       %~dp0HARBOUR_README_POCC                                                   %HB_ABSROOT%comp\pocc\
xcopy /y       %~dp0HARBOUR_README_WATCOM                                                 %HB_ABSROOT%comp\watcom\

xcopy /y /s    %~dp0..\..\pkg\win\mingw\harbour-%HB_VF%-win-mingw                         %HB_ABSROOT%

xcopy /y /s    %~dp0..\..\pkg\linux\watcom\harbour-%HB_VF%-linux-watcom\lib               %HB_ABSROOT%lib\linux\watcom\
xcopy /y /s    %~dp0..\..\pkg\dos\watcom\hb%HB_VL%wa\lib                                  %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\os2\watcom\harbour-%HB_VF%-os2-watcom\lib                   %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\wce\mingwarm\harbour-%HB_VF%-wce-mingwarm\lib               %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\bcc\harbour-%HB_VF%-win-bcc\lib                         %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\mingw\harbour-%HB_VF%-win-mingw\lib                     %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\lib                 %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\msvc\harbour-%HB_VF%-win-msvc\lib                       %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\msvc64\harbour-%HB_VF%-win-msvc64\lib                   %HB_ABSROOT%lib\
xcopy /y /s    %~dp0..\..\pkg\win\watcom\harbour-%HB_VF%-win-watcom\lib                   %HB_ABSROOT%lib\

xcopy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\*.dll           %HB_ABSROOT%bin\
xcopy /y       %~dp0..\..\pkg\wce\mingwarm\harbour-%HB_VF%-wce-mingwarm\bin\*.dll         %HB_ABSROOT%bin\

rem ; Create special implibs for Borland (requires BCC in PATH)
for %%a in ( %HB_ABSROOT%bin\*-%HB_VS%.dll ) do "%HB_DIR_BCC_IMPLIB%implib.exe" -c -a %HB_ABSROOT%lib\win\bcc\%%~na-bcc.lib %%a

 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\harbour.exe     %HB_ABSROOT%bin\harbour-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbformat.exe    %HB_ABSROOT%bin\hbformat-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbi18n.exe      %HB_ABSROOT%bin\hbi18n-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbmk2.exe       %HB_ABSROOT%bin\hbmk2-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbnetio.exe     %HB_ABSROOT%bin\hbnetio-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbpp.exe        %HB_ABSROOT%bin\hbpp-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbrun.exe       %HB_ABSROOT%bin\hbrun-x64.exe
 copy /y       %~dp0..\..\pkg\win\mingw64\harbour-%HB_VF%-win-mingw64\bin\hbtest.exe      %HB_ABSROOT%bin\hbtest-x64.exe

xcopy /y       "%HB_DIR_UPX%upx.exe"                                                      %HB_ABSROOT%bin\
 copy /y       "%HB_DIR_UPX%LICENSE"                                                      %HB_ABSROOT%bin\upx_LICENSE.txt

xcopy /y /s /e "%HB_DIR_MINGW%"                                                           %HB_ABSROOT%comp\mingw\
rem del %HB_ABSROOT%comp\mingw\tdm-mingw-1.908.0-4.4.1-2.exe

xcopy /y       "%HB_DIR_MINGW%\bin\libgcc_s_dw2-1.dll"                                    %HB_ABSROOT%bin\
xcopy /y       "%HB_DIR_MINGW%\bin\mingwm10.dll"                                          %HB_ABSROOT%bin\

xcopy /y       "%HB_WITH_QT%\..\bin\QtCore4.dll"                                          %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\bin\QtGui4.dll"                                           %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\bin\QtNetwork4.dll"                                       %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\bin\QtSql4.dll"                                           %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\bin\uic.exe"                                              %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\bin\rcc.exe"                                              %HB_ABSROOT%bin\
xcopy /y       "%HB_WITH_QT%\..\lib\libQtCore4.a"                                         %HB_ABSROOT%lib\win\mingw\
xcopy /y       "%HB_WITH_QT%\..\lib\libQtGui4.a"                                          %HB_ABSROOT%lib\win\mingw\
xcopy /y       "%HB_WITH_QT%\..\lib\libQtNetwork4.a"                                      %HB_ABSROOT%lib\win\mingw\
xcopy /y       "%HB_WITH_QT%\..\lib\libQtSql4.a"                                          %HB_ABSROOT%lib\win\mingw\
 copy /y       "%HB_WITH_QT%\..\LICENSE.LGPL"                                             %HB_ABSROOT%bin\Qt_LICENSE_LGPL.txt
 copy /y       "%HB_WITH_QT%\..\LGPL_EXCEPTION.txt"                                       %HB_ABSROOT%bin\Qt_LICENSE_LGPL_EXCEPTION.txt

if exist %HB_ABSROOT%lib\win\mingw\  xcopy /y       "%HB_DIR_UNICOWS%\mingw\libunicows.a"                                      %HB_ABSROOT%lib\win\mingw\
if exist %HB_ABSROOT%lib\win\mingw\  xcopy /y       "%HB_DIR_UNICOWS%\mingw\unicows_license.txt"                               %HB_ABSROOT%lib\win\mingw\
if exist %HB_ABSROOT%lib\win\watcom\ xcopy /y       "%HB_DIR_UNICOWS%\watcom\unicows.lib"                                      %HB_ABSROOT%lib\win\watcom\
if exist %HB_ABSROOT%lib\win\watcom\ xcopy /y       "%HB_DIR_UNICOWS%\watcom\unicows_license.txt"                              %HB_ABSROOT%lib\win\watcom\
if exist %HB_ABSROOT%lib\win\bcc\    xcopy /y       "%HB_DIR_UNICOWS%\bcc\unicows.lib"                                         %HB_ABSROOT%lib\win\bcc\
if exist %HB_ABSROOT%lib\win\bcc\    xcopy /y       "%HB_DIR_UNICOWS%\bcc\unicows_license.txt"                                 %HB_ABSROOT%lib\win\bcc\

pushd

cd %~dp0..\..\contrib

for /F %%a in ( 'dir /b /ad' ) do (
   echo %%a
   xcopy /y /s %%a\*.def     %HB_ABSROOT%contrib\%%a\
   xcopy /y /s %%a\*.hbs     %HB_ABSROOT%contrib\%%a\
   xcopy /y /s %%a\*.txt     %HB_ABSROOT%contrib\%%a\
   xcopy /y /s %%a\tests\*.* %HB_ABSROOT%contrib\%%a\tests\
)

xcopy /y /s *.hbc %HB_ABSROOT%contrib

popd

rem ; Create unified installer

pushd

cd %HB_RT%

if exist %HB_RT%harbour-%HB_VF%-win-log.txt del %HB_RT%harbour-%HB_VF%-win-log.txt
if exist %HB_RT%harbour-%HB_VF%-win.exe del %HB_RT%harbour-%HB_VF%-win.exe

"%HB_DIR_NSIS%makensis.exe" %HB_OPT_NSIS% %~dp0mpkg_win_uni.nsi >> %HB_RT%harbour-%HB_VF%-win-log.txt 2>&1

rem ; Create unified archive

echo.> _hbfiles
echo "%HB_DR%RELNOTES"                              >> _hbfiles
echo "%HB_DR%INSTALL"                               >> _hbfiles
echo "%HB_DR%COPYING"                               >> _hbfiles
echo "%HB_DR%NEWS"                                  >> _hbfiles
echo "%HB_DR%TODO"                                  >> _hbfiles
echo "%HB_DR%ChangeLog*"                            >> _hbfiles
echo "%HB_DR%bin\harbour-%HB_VS%.dll"               >> _hbfiles
echo "%HB_DR%bin\harbour.exe"                       >> _hbfiles
echo "%HB_DR%bin\hbformat.exe"                      >> _hbfiles
echo "%HB_DR%bin\hbi18n.exe"                        >> _hbfiles
echo "%HB_DR%bin\hbmk2.exe"                         >> _hbfiles
echo "%HB_DR%bin\hbmk2.*.hbl"                       >> _hbfiles
echo "%HB_DR%bin\hbnetio.exe"                       >> _hbfiles
echo "%HB_DR%bin\hbpp.exe"                          >> _hbfiles
echo "%HB_DR%bin\hbrun.exe"                         >> _hbfiles
echo "%HB_DR%bin\hbtest.exe"                        >> _hbfiles
if exist "%HB_DR%bin\hbide.exe"                     echo "%HB_DR%bin\hbide.exe"                     >> _hbfiles
if exist "%HB_DR%bin\libgcc_s_dw2-1.dll"            echo "%HB_DR%bin\libgcc_s_dw2-1.dll"            >> _hbfiles
if exist "%HB_DR%bin\mingwm10.dll"                  echo "%HB_DR%bin\mingwm10.dll"                  >> _hbfiles
if exist "%HB_DR%bin\QtCore4.dll"                   echo "%HB_DR%bin\QtCore4.dll"                   >> _hbfiles
if exist "%HB_DR%bin\QtGui4.dll"                    echo "%HB_DR%bin\QtGui4.dll"                    >> _hbfiles
if exist "%HB_DR%bin\QtNetwork4.dll"                echo "%HB_DR%bin\QtNetwork4.dll"                >> _hbfiles
if exist "%HB_DR%bin\QtSql4.dll"                    echo "%HB_DR%bin\QtSql4.dll"                    >> _hbfiles
if exist "%HB_DR%bin\uic.exe"                       echo "%HB_DR%bin\uic.exe"                       >> _hbfiles
if exist "%HB_DR%bin\rcc.exe"                       echo "%HB_DR%bin\rcc.exe"                       >> _hbfiles
if exist "%HB_DR%bin\Qt_LICENSE_LGPL.txt"           echo "%HB_DR%bin\Qt_LICENSE_LGPL.txt"           >> _hbfiles
if exist "%HB_DR%bin\Qt_LICENSE_LGPL_EXCEPTION.txt" echo "%HB_DR%bin\Qt_LICENSE_LGPL_EXCEPTION.txt" >> _hbfiles
if exist "%HB_DR%bin\hbmk.hbc"                      echo "%HB_DR%bin\hbmk.hbc"                      >> _hbfiles
echo "%HB_DR%bin\upx*.*"                            >> _hbfiles
echo "%HB_DR%include\*.*"                           >> _hbfiles
echo "%HB_DR%bin\harbour-x64.exe"                   >> _hbfiles
echo "%HB_DR%bin\hbformat-x64.exe"                  >> _hbfiles
echo "%HB_DR%bin\hbi18n-x64.exe"                    >> _hbfiles
echo "%HB_DR%bin\hbmk2-x64.exe"                     >> _hbfiles
echo "%HB_DR%bin\hbnetio-x64.exe"                   >> _hbfiles
echo "%HB_DR%bin\hbpp-x64.exe"                      >> _hbfiles
echo "%HB_DR%bin\hbrun-x64.exe"                     >> _hbfiles
echo "%HB_DR%bin\hbtest-x64.exe"                    >> _hbfiles
echo "%HB_DR%lib\win\mingw\*.*"                     >> _hbfiles
echo "%HB_DR%lib\win\mingw64\*.*"                   >> _hbfiles
echo "%HB_DR%lib\wce\mingwarm\*.*"                  >> _hbfiles
echo "%HB_DR%addons\HARBOUR_README_ADDONS"          >> _hbfiles
rem echo "%HB_DR%comp\djgpp\HARBOUR_README_DJGPP"       >> _hbfiles
echo "%HB_DR%comp\watcom\HARBOUR_README_WATCOM"     >> _hbfiles
echo "%HB_DR%comp\pocc\HARBOUR_README_POCC"         >> _hbfiles
echo "%HB_DR%comp\mingw\HARBOUR_README_MINGW"       >> _hbfiles
echo "%HB_DR%comp\mingw64\HARBOUR_README_MINGW64"   >> _hbfiles
echo "%HB_DR%comp\mingwarm\HARBOUR_README_MINGWARM" >> _hbfiles
rem echo "%HB_DR%lib\dos\djgpp\*.*"                     >> _hbfiles
echo "%HB_DR%lib\dos\watcom\*.*"                    >> _hbfiles
echo "%HB_DR%lib\linux\watcom\*.*"                  >> _hbfiles
echo "%HB_DR%lib\os2\watcom\*.*"                    >> _hbfiles
echo "%HB_DR%lib\win\msvc\*.*"                      >> _hbfiles
echo "%HB_DR%lib\win\msvc64\*.*"                    >> _hbfiles
rem echo "%HB_DR%bin\harbour-20-bcc.dll"                >> _hbfiles
echo "%HB_DR%lib\win\bcc\*.*"                       >> _hbfiles
echo "%HB_DR%lib\win\watcom\*.*"                    >> _hbfiles
rem echo "%HB_DR%lib\win\pocc\*.*"                      >> _hbfiles
rem echo "%HB_DR%lib\win\pocc64\*.*"                    >> _hbfiles
rem echo "%HB_DR%lib\wce\poccarm\*.*"                   >> _hbfiles
echo "%HB_DR%bin\harbour-%HB_VS%-x64.dll"           >> _hbfiles
echo "%HB_DR%bin\harbour-%HB_VS%-wce-arm.dll"       >> _hbfiles
rem echo "%HB_DR%bin\harbour-%HB_VS%-os2.dll"           >> _hbfiles
echo "%HB_DR%tests\*.*"                             >> _hbfiles
echo "%HB_DR%doc\*.*"                               >> _hbfiles
echo "%HB_DR%comp\mingw\*"                          >> _hbfiles
echo "%HB_DR%examples\*.*"                          >> _hbfiles
echo "%HB_DR%contrib\*.*"                           >> _hbfiles

if exist %HB_RT%harbour-%HB_VF%-win.7z del %HB_RT%harbour-%HB_VF%-win.7z
"%HB_DIR_7Z%7za.exe" a -r %HB_RT%harbour-%HB_VF%-win.7z @_hbfiles >> %HB_RT%harbour-%HB_VF%-win-log.txt 2>&1

del _hbfiles

popd
