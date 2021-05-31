@ECHO OFF

:: Example de batch utilisant les sprites de batbox
:: Ceci est un logiciel libre, vous pouver le distribuer selon
:: les termes de la licence GNU GPL


TITLE Exemple de sprite avec batbox

COLOR 0A

set offsetX=0
set offsetY=0


:Loop

CLS

batbox /o %offsetX% %offsetY% /g 2 0 /a 219 /g 8 0 /a 219 /g 3 1 /a 219 /g 7 1 /a 219 /g 2 2 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /g 1 3 /a 219 /a 219 /g 4 3 /a 219 /a 219 /a 219 /g 8 3 /a 219 /a 219 /g 0 4 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /g 0 5 /a 219 /g 2 5 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /a 219 /g 10 5 /a 219 /g 0 6 /a 219 /g 2 6 /a 219 /g 8 6 /a 219 /g 10 6 /a 219 /g 3 7 /a 219 /a 219 /g 6 7 /a 219 /a 219 /g 0 9 /d "Teleporte Moi"
Call :Mouse_ offsetX OffsetY type

GOTO :Loop


:: Mouse ptrX ptrY ptrType
:: ptrX : pointeur sur la variable qui recevra la colone
:: ptrY : pointeur sur la variable qui recevra la ligne
:: ptrType : pointeur sur la variable qui recevra le Type
:Mouse_
FOR /F "tokens=1,2,3 delims=:" %%A in ('BatBox /m') DO (
	SET %3=%%C
	SET %2=%%B
	SET %1=%%A
)
GOTO:EOF
