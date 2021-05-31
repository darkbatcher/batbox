; BatBox.exe - copyleft (c) Darkbatcher 2011 - 2013
; Cet source est distribuée sous licence GNU GPL

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

EVENT_TYPE_MOUSE=2
COORD_MASK=$0000FFFF
EVENT_FLAG_MASK=$FFFFFFFD
; utilisation des registres
; ebx pointe sur l'argument courrant



; import data in the same section
	 invoke __getmainargs,argc,argv,bin,0,bin
	 invoke GetStdHandle,STD_OUTPUT_HANDLE
	 mov	[hOut],eax
	 invoke GetStdHandle,STD_INPUT_HANDLE
	 mov	[hIn],eax
	 argsLoop_:
		call	near GetNextArg_
		inc	ebx
		mov	byte dl,[ebx]
		or	dl,$20
		; now seaching for the right label to follow
		xor	edi,edi
		mov	cx,9
		LabelLoop_:
			cmp byte dl,[jumpChar+edi]
			je  near ChooseJump_
			inc edi
			loopw LabelLoop_
			jmp near argsLoop_

				Color_:
				       call    near GetNextNumber_
				       invoke	    SetConsoleTextAttribute,[hOut],eax
				       jmp     near argsLoop_

				Key_:
					cmp	     byte [ebx+1],'_'
					jnz    near KeyNext_
							     invoke	  _kbhit
							     test	  eax,eax
							     jz      near argsLoop_
				       KeyNext_:
				       invoke	    getch
				       cmp	    eax,224
				       jnz     near KeyEnd_
							     invoke	  getch
							     add	  eax,255
				       KeyEnd_:
				       invoke	    exit,eax

				Goto_:
					call	near GetNextNumber_
					add	     eax,[dwXOffset]
					and	     eax,$0000FFFF
					mov	     [p],eax
					call	near GetNextNumber_
					add	     eax,[dwYOffset]
					shl	     eax,16
					add	     [p],eax
					invoke	     SetConsoleCursorPosition,[hOut],[p]
					jmp	near argsLoop_
				Char_:
					call	near GetNextNumber_
					invoke	     printf,chrMask,eax
					jmp	near argsLoop_

				Fullscreen_:
					call	near GetNextNumber_
					inc	     eax
					invoke	     SetConsoleDisplayMode,[hOut],eax,0
					jmp	near argsLoop_

				Disp_:
					call	near GetNextArg_
					invoke	     printf,strMask,ebx
					jmp	near argsLoop_

				Mouse_:
					invoke	     SetConsoleMode,[hIn],0x0018 ;ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT
					invoke	     ReadConsoleInput,[hIn],input,1,bin
					cmp	     [bin],0
					jz	near Mouse_
					cmp	     [input.EventType],EVENT_TYPE_MOUSE
					jne	     near Mouse_

					test	     [input.dwEventFlags],EVENT_FLAG_MASK
					jnz	near Mouse_
					mov	     edi,[input.dwMousePosition]
					mov	     esi,edi
					shr	     edi,16
					and	     esi,COORD_MASK
					mov	     eax,[input.dwButtonState]
					test	     eax,eax
					jz	near Mouse_
					add	     eax,[input.dwEventFlags]
					invoke	     printf,mouseMask,esi,edi,eax
					jmp	near argsLoop_
				Wait_:
					call	near GetNextNumber_
					invoke	     Sleep,eax
					jmp	near argsLoop_
				Offset_:
					call	near GetNextNumber_
					mov	     [dwXOffset], eax
					call	near GetNextNumber_
					mov	     [dwYOffset], eax
					jmp	near argsLoop_


proc	GetNextNumber_
	call	     GetNextArg_
	cinvoke       strtol,ebx,0,0
	ret
endp

ChooseJump_:
	shl edi,2
	jmp [jumpTable+edi]

GetNextArg_:
	add	[argv],4
	mov	ebx,[argv]
	mov	ebx,[ebx]
	test	ebx,ebx
	jz	near EndCommand_
	ret
EndCommand_:
	invoke	exit,0

strMask      db '%s',0
mouseMask    db '%d:%d:%d',0
chrMask      db '%c',0
jumpTable    dd Key_,Goto_,Char_,Color_,Fullscreen_,Disp_,Mouse_,Offset_,Wait_
jumpChar     db 'kgacfdmow'
dwXOffset    dd 0
dwYOffset    dd 0

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
	strtol,'strtol'


end data

argc	  dd ?
argv	  dd ?
hIn	  dd ?
hOut	  dd ?
bin	  dd ?
p	  dd ?

input	INPUT_RECORD ?