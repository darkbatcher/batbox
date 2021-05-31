@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

ECHO Creation des fichiers

SET PATH=%path%;%cd%/doc_gen

IF not exist doc MKDIR doc
IF not exist doc\text MKDIR doc\text
IF not exist doc\html MKDIR doc\html

IF not exist doc\html\_batbox MKDIR doc\html\_batbox
IF not exist doc\text\_batbox MKDIR doc\text\_batbox

ECHO génération des fichiers de documentation

For /r "man" %%A in (*.*) do (
   
   set dir=

   For /f %%B in ('ECHO %%~A ^| find "_batbox"') do (
	set dir=_batbox/
   )

   iconv -f CP863 -t UTF-8 "%%~A" > "%%~A.tmp"
   tea "%%~A.tmp" "doc/html/!dir!%%~nA.html" /E:UTF-8 /O:HTML /F "/F doc_gen/footer.html"
   tea "%%~A.tmp" "doc/text/!dir!%%~nA.txt" /E:UTF-8 /O:TEXT

)


ECHO Nettoyage des tmp

for /r "./man" %%A in (*.tmp) DO (
  DEL /S /Q "%%~A"
)

pause