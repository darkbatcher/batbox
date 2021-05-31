@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

TITLE Liste des code couleurs utilisables avec BatBox

:: Example de batch utilisant les couleurs de batbox
:: Ceci est un logiciel libre, vous pouver le distribuer selon
:: les termes de la licence GNU GPL

ECHO  Liste des code couleurs utilisables avec BatBox %TIME%
ECHO.
set x=0
set yBckp=1
FOR %%A IN (0 1 2 3 4 5 6 7 8 9 A B C D E F) DO (
FOR %%B IN (0 1 2 3 4 5 6 7 8 9 A B C D E F) DO (
set /a y=!y!+1
BATBOX /g !x! !y! /c 0x%%A%%B /d "couleur : 0x%%A%%B"
ECHO.
)
set /a x=!x!+14
if !x! GTR 69 (
set x=0
set /a yBckp=!yBckp!+16
)
set /a y=!yBckp!
)
batbox /c 0x0f
ECHO %TIME%
PAUSE>NUL