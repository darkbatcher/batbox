@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

CHCP 65001 > NUL


ECHO Script de génération de fichiers de documentations pour BatBox.
ECHO 	copyleft (c) Darkbatcher 2013 
ECHO.
ECHO Ceci est un logiciel libre distribué sous Licence Publique Générale GNU (GNU 
ECHO GPL)
ECHO.
ECHO Création des dossiers et fichiers
ECHO	Succès ^!
ECHO.

SET PATH=%path%;%cd%/doc_gen

IF not exist doc MKDIR doc
IF not exist doc\text MKDIR doc\text
IF not exist doc\html MKDIR doc\html

for %%A in (doc
doc\text
doc\html
doc\text\en
doc\text\fr
doc\text\en\_batbox
doc\text\fr\_batbox
doc\html\fr
doc\html\fr\_batbox
doc\html\en
doc\html\en\_batbox ) do (
	
	IF NOT EXIST %%A MKDIR %%A

)


ECHO Génération des fichiers de documentation

SET TEA_TEXT_LINKS=voir
set FOOTER=doc_gen/footer_fr.html
set TITLE=BatBox - Documentation ::
set META=doc_gen/meta.html

For /r "man\fr" %%A in (*.*) do (
   
   set htmlPath=%%~dpnA.html
   set htmlPath=!htmlPath:man=doc/html!
   
   set textPath=%%~dpnA.txt
   set textPath=!textPath:man=doc/text!

   ECHO 	Traitement de "%%~A"
   ECHO			Vers "!htmlPath!"
   
   tea "%%~A" "!htmlPath!" /E:UTF-8 /O:HTML /F "%FOOTER%" /T "%TITLE%" /M "%META%" > NUL
   
   ECHO			Vers "!textPath!"
   
   tea "%%~A" "!textPath!" /E:UTF-8 /O:TEXT > NUL
   
)

SET TEA_TEXT_LINKS=
set FOOTER=doc_gen/footer_en.html

For /r "man\en" %%A in (*.*) do (
   
   set htmlPath=%%~dpnA.html
   set htmlPath=!htmlPath:man=doc/html!
   
   set textPath=%%~dpnA.txt
   set textPath=!textPath:man=doc/text!

   ECHO 	Traitement de "%%~A"
   ECHO			Vers "!htmlPath!"
   
   tea "%%~A" "!htmlPath!" /E:UTF-8 /O:HTML /F "%FOOTER%" /T "%TITLE%" /M "%META%"> NUL
   
   ECHO			Vers "!textPath!"
   
   tea "%%~A" "!textPath!" /E:UTF-8 /O:TEXT > NUL
   
)

ECHO Succès ^^^!
ECHO.
pause>NUL