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
::
if "%1" equ "/?" goto :help

ECHO *** Configuring the batbox package ***
ECHO Copyright (c) 2014 Romain GARBI (Darkbatcher)
ECHO.
ECHO Resetting configured file ...
(ECHO ; Configured by batbox configure.bat
ECHO. )> src/config.inc
ECHO 	done !
ECHO.

set use_bb_file=yes
set use_x_option=no

:argloop

if "%1" equ "no-bb-file" set use_bb_file=no
if "%1" equ "with-x-option" set use_x_option=yes
if "%1" equ "" goto :write_config
shift /1

goto :argLoop


:write_config
ECHO Generating src/config.inc configuration file ...
ECHO 		- Use .bb backup file ... %use_bb_file%
(ECHO ; define to 1 if you want to use .bb file
ECHO USE_BB_FILE equ %use_bb_file%) >> src/config.inc
ECHO 		- Include '/x' option ... %use_x_option%
(ECHO ; define to 1 if you want to include x file
ECHO USE_X_OPTION equ %use_x_option% ) >> src/config.inc
ECHO 	done !
GOTO:EOF

:help
ECHO BatBox configuration tool
ECHO Copyright (c) 2014 Romain GARBI (Darkbatcher)
ECHO.
ECHO 	configure.bat [options ...]
ECHO.
ECHO 	Configure the batbox package before building it with
ECHO 	Make_bin.bat
ECHO.
ECHO 	Options may be one of the following
ECHO.
ECHO		- no-bb-file : Do not use the '.bb' file as a backup file
ECHO		  for command '/o' and '/n'.
ECHO		- with-x-option : Include the '/x' option.
ECHO.
ECHO Please report bugs at: darkbatcher at dos9 dot org
ECHO.