format PE CONSOLE 4.0

include 'win32a.inc'

struct INPUT_RECORD
     EventType dw ?
     nul dw ?
     dwMousePosition dd ?
     dwButtonState dd ?
     dwControlKeyState dd ?
     dwEventFlags dd ?
ends


; utilisation des registres
; ebx pointe sur l'argument courrant



; import data in the same section
         invoke __getmainargs,argc,argv,bin,0,bin
         invoke GetStdHandle,STD_OUTPUT_HANDLE
         mov    [hOut],eax
         invoke GetStdHandle,STD_INPUT_HANDLE
         mov    [hIn],eax
         argsLoop_:
                call   GetNextArg_
                cmp     byte [ebx],'/'
                jnz     EndCommand_ ; si la ligne n'est pas un commutateur
                inc     ebx
                xor     eax,eax
                mov     al,[ebx]
                or      al,$20
                cmp     al,'k'
                je      Key_
                cmp     al,'g'
                je      Goto_
                cmp     al,'c'
                je      Color_
                cmp     al,'a'
                je      Char_
                cmp     al,'f'
                je      Fullscreen_
                cmp     al,'d'
                je      Disp_
                cmp     al,'m'
                je      Mouse_
                cmp     al,'w'
                je      Wait_
                jmp     EndCommand_
                                Color_:
                                   call         GetNextArg_
                                   invoke       strtol,ebx,0,0
                                   invoke       SetConsoleTextAttribute,[hOut],eax
                                   jmp          argsLoop_
                                Key_:
                                   invoke       strchr,ebx,'_'
                                   test         eax,eax
                                   jz           KeyNext_
                                                invoke       _kbhit
                                                test         eax,eax
                                                jz           argsLoop_
                                   KeyNext_:
                                   invoke       getch
                                   cmp          eax,224
                                   jnz          KeyEnd_
                                                invoke       getch
                                                add          eax,255
                                   KeyEnd_:
                                   invoke       exit,eax
                                Goto_:
                                   call         GetNextArg_
                                   invoke       strtol,ebx,0,0
                                   mov          [p],eax
                                   call         GetNextArg_
                                   invoke       strtol,ebx,0,0
                                   shl          eax,16
                                   add          [p],eax
                                   invoke       SetConsoleCursorPosition,[hOut],[p]
                                   jmp          argsLoop_
                                Char_:
                                        call         GetNextArg_
                                        invoke       strtol,ebx,0,0
                                        invoke       printf,chrMask,eax
                                        jmp          argsLoop_
                                Fullscreen_:
                                        call         GetNextArg_
                                        invoke       strtol,ebx,0,0
                                        invoke       SetConsoleDisplayMode,[hOut],eax,0
                                        jmp          argsLoop_
                                Disp_:
                                        call         GetNextArg_
                                        invoke       printf,strMask,ebx
                                        jmp          argsLoop_
                                Mouse_:
                                        invoke SetConsoleMode,[hIn],0x0018 ;ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT
                                        invoke       ReadConsoleInput,[hIn],input,1,bin
                                        cmp          [bin],0
                                        jz           Mouse_
                                        cmp          [input.EventType],2
                                        jne          Mouse_
                                        or           [input.dwEventFlags],2
                                        cmp          [input.dwEventFlags],2
                                        jne          Mouse_
                                        mov          edi,[input.dwMousePosition]
                                        mov          esi,edi
                                        shr          edi,16
                                        and          esi,$0000FFFF
                                        mov          eax,[input.dwButtonState]
                                        add          eax,[input.dwEventFlags]
                                        invoke       printf,mouseMask,esi,edi,eax
                                        jmp          argsLoop_
                                Wait_:
                                        call         GetNextArg_
                                        invoke       strtol,ebx,0,0
                                        invoke       Sleep,eax
                                        jmp     argsLoop_

GetNextArg_:
        add     [argv],4
        mov     ebx,[argv]
        mov     ebx,[ebx]
        test    ebx,ebx
        jz      EndCommand_
        ret
EndCommand_:
        invoke  exit,0

strMask    db '%s',0
mouseMask    db '%d:%d:%d',0
chrMask       db '%c',0

data import
 library msvcrt, 'MSVCRT.DLL',\
         kernel,'KERNEL32.DLL'

 import kernel,\
        GetStdHandle,'GetStdHandle',\
        SetConsoleMode,'SetConsoleMode',\
        SetConsoleTextAttribute,'SetConsoleTextAttribute',\
        SetConsoleCursorPosition,'SetConsoleCursorPosition',\
        ReadConsoleInput,'ReadConsoleInputA',\
        Sleep,'Sleep',\
        SetConsoleDisplayMode,'SetConsoleDisplayMode'
 import msvcrt,\
        printf, 'printf',\
        getch,'_getch',\
        __getmainargs,'__getmainargs',\
        exit,'exit',\
        _kbhit,'_kbhit',\
        strtol,'strtol',\
        strchr,'strchr'
end data
argc    dd ?
argv    dd ?
hIn     dd ?
hOut    dd ?
bin     dd ?
p       dd ?
input   INPUT_RECORD