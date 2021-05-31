@ECHO OFF
:: Copyright (c) 2014, Romain GARBI (Darkbatcher)
:: All rights reserved.
:: Redistribution and use in source and binary forms, with or without
:: modification, are permitted provided that the following conditions are met:
::
:: * Redistributions of source code must retain the above copyright
::   notice, this list of conditions and the following disclaimer.
:: * Redistributions in binary form must reproduce the above copyright
::   notice, this list of conditions and the following disclaimer in the
::   documentation and/or other materials provided with the distribution.
:: * Neither the name of the name of Romain Garbi (Darkbatcher) nor the
::   names of its contributors may be used to endorse or promote products
::   derived from this software without specific prior written permission.
::
:: THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
:: EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
:: WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
:: DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
:: DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
:: (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES::
:: LOSS OF USE, DATA, OR PROFITS:: OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
:: ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
:: (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
:: SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CHCP 65001 > NUL

:: Setup the path environment
SET path=%path%;%cd%/bin_gen;%cd%/fasm

:: Setup the include directory for fasm
SET INCLUDE=%cd%\fasm\include


:: Run the fasm compiler
cd src

ECHO compiling the source... 
fasm BATBOX.asm
ECHO done !
cd ..

ECHO.
ECHO Copying the files in right folder...

(copy src\batbox.exe exemples\batbox.exe
copy src\batbox.exe bin\batbox.exe
copy spritebox\spritebox.exe bin\spritebox.exe ) > NUL
ECHO done !
ECHO.

ECHO Generating compressed file ...
makecab "bin/batbox.exe" "bin/batbox.ex_" > NUL
ECHO done !
ECHO.
ECHO Generating automatic generation code

ECHO for %%%%b in ( > bin/makebb.bat

Dump /B /H bin/batbox.ex_ >> bin/makebb.bat

(ECHO ^) Do ^>^>t.dat ^(Echo.For b=1 To len^^^("%%%%b"^^^) Step 2
Echo ECHO WScript.StdOut.Write Chr^^(Clng^^("&H"^^^&Mid^^^("%%%%b",b,2^^^)^^^)^^^) : Next^)
ECHO Cscript /b /e:vbs t.dat^>batbox.ex_
ECHO Del /f /q /a t.dat ^>nul 2^>^&1
ECHO Expand -r batbox.ex_ ^>nul 2^>^&1
ECHO Del /f /q /a batbox.ex_ ^>nul 2^>^&1
) >> bin/makebb.bat


del bin\batbox.ex_ /S /Q > nul 2>&1
ECHO Done !
ECHO.