@ECHO OFF
set X=0
set Y=0

batbox /h 0

:loop
batbox /x pac.spr %X% %Y% /a 0xb1 /k

If %ERRORLEVEL%==335 set /a Y+=1
If %ERRORLEVEL%==332 set /a X+=1
If %ERRORLEVEL%==327 set /a Y-=1
If %ERRORLEVEL%==330 set /a X-=1

goto :loop

PAUSE>NUL