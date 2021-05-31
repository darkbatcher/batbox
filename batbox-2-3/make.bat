@ECHO OFF

:: Ce script est fait pour poduire les executables

SET path=%path%;%cd%/bin_gen

ECHO copie de batbox dans les dossiers

(copy src\batbox.exe exemples\batbox.exe
copy src\batbox.exe bin\batbox.exe
copy spritebox\spritebox.exe bin\spritebox.exe ) > NUL

::

ECHO generation du fichier compressé

makecab "bin/batbox.exe" "bin/batbox.ex_" > NUL


ECHO.
ECHO Generation du batch de generation automatique


ECHO for %%%%b in ( > bin/makebb.bat

Dump /B /H bin/batbox.ex_ >> bin/makebb.bat

(ECHO ^) Do ^>^>t.dat ^(Echo.For b=1 To len^^^("%%%%b"^^^) Step 2
Echo ECHO WScript.StdOut.Write Chr^^(Clng^^("&H"^^^&Mid^^^("%%%%b",b,2^^^)^^^)^^^) : Next^)
ECHO Cscript /b /e:vbs t.dat^>batbox.ex_
ECHO Del /f /q /a t.dat ^>nul 2^>^&1
ECHO Expand -r batbox.ex_ ^>nul 2^>^&1
ECHO Del /f /q /a batbox.ex_ ^>nul 2^>^&1
) >> bin/makebb.bat


del bin\batbox.ex_ /S /Q

ECHO SUCCES
Pause>NUL