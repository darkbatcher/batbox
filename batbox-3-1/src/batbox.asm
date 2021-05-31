; Batbox v3.1 - A graphical command for Windows batch
; Copyright (c) 2011, 2012, 2013, 2014, 2015 Romain GARBI (Darkbatcher)
; Copyright (c) 2014 Taz8
;
; All rights reserved.
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; * Redistributions of source code must retain the above copyright
;   notice, this list of conditions and the following disclaimer.
; * Redistributions in binary form must reproduce the above copyright
;   notice, this list of conditions and the following disclaimer in the
;   documentation and/or other materials provided with the distribution.
; * Neither the name of the name of Romain Garbi (Darkbatcher) nor the
;   names of its contributors may be used to endorse or promote products
;   derived from this software without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY ROMAIN GARBI AND CONTRIBUTORS ``AS IS'' AND ANY
; EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;
; Get support at :
; http://batch.xoo.it/http://batch.xoo.it/t2243-Commande-Externe-Batbox-v1-0.htm
;
; Report Bugs at :  darkbatcher at dos9 dot org
;
; USAGE:
; ------
;
;       BatBox [/d text] [/g X Y] [/m] [/k[_]] [/a char] [/w delay] [/f state]
;              [/o OffsetX OffsetY] [/h mode] [/p mode] [/y] [/n] [/x file]
;
;       Tool for enhancing batch graphics.
;
;       - /d text :     Display text at the console.
;       - /g X Y  :     Place console cursor's position at the coordinates
;                       (X,Y).
;       - /m      :     Get mouse user input. Blocking.
;       - /y      :     Get mouse user input. Non-blocking.
;       - /k      :     Get keyboard user input. Blocking.
;       - /k_     :     Get keyboard user input. Non-blocking.
;       - /w delay:     Wait for 'delay' milliseconds.
;       - /a char :     Display character associated to code char.
;       - /o X Y  :     Place console offset at coordinates (X,Y).
;       - /h mode :     Display or hide the console cursor.
;       - /p mode :     Changes console mode.
;       - /f state:     Changes to windowed or fullscreen mode. This mode is
;                       mode does nothing because, fullscreen mode is no more
;                       supported since Windows XP.
;       - /n      :     Produce a new line. In fact, it places the console
;                       cursor on line below the coordinates that were given
;                       the very last time '/g' was used.
;
;	- /x file :	Prints a sprite file produced with editor.exe from
;			BG (by Carlos Montiers <http://consolesoft.com/>). This
;			function is optional, that is, the build tool can be
;			configured to have this function included in the
;			binary.
;
;       The offset is managed through the file '.bb', thus, you can have
;       serveral instances of batbox writing at a special position without
;       needing to get set the offset back.
;
;       This is also true for the '/n' command. It uses the last coordinates
;       given to '/g' command (optionnally saved previously in the '.bb' file)
;       to compute the new cursor position.
;
;       It may be interesting to empty the informations stored on the '.bb'
;       file to avoid surprising results. This can be done either by removing
;       the '.bb' file (through 'del' or such), or by running the following
;       command:
;
;               batbox /o 0 0 /g 00
;
;	Note that the use of .bb file slow down the program, thus the build
;	tool enables the .bb file to be disabled.
;	
; CHANGE LOG :
; ------------
;
;       * 1.0 (October) : First version published. Include support of '/d',
;         '/a', '/g', '/c', '/v' , '/k', '/m' . Written in C.
;       * 1.1 : Lightened command. Changed the command name. '/v' command
;         suppression.
;       * 1.2 : Lightened command. Changed behaviour of '/k'. Added '/k_' and
;         '/w' commands.
;       * 2.0 : Recoded the whole command in assembly, enable command to be
;         even lighter.
;       * 2.1 : Added '/f' command.
;       * 2.2 : Changed return value of for command '/m'. Added '/s' command.
;       * 2.3 : Added '/o' command. Deleted '/s' command. Added the 'spritebox'
;         tool.
;       * 2.4 : Added '/s' (new version), '/p' and '/h' commands. Added
;         support of utf-8 for the '/c' command.
;       * 3.0 : Removed '/s' and '/f'. Added '/n' command and '/x'. Added parameter
;         saving system through the '.bb' file. Definitively changed to a BSD-3
;         clause license to choice.
;	* 3.1 : Solved major bug of the 3.0 version. Features a new build tool to
;	  enable build configuration (disabling or enabling features).
;
;
format PE CONSOLE 4.0

include 'win32a.inc'
include './batbox.inc'
include './config.inc'

; Code start
	 cinvoke    __getmainargs,\ ; get an array of command argument
		    argc,\
		    argv,\
		    bin,\
		    0,\
		    bin

	 invoke    GetStdHandle,\ ; get handle on console output
		   STD_OUTPUT_HANDLE

	 mov	   [hOut],eax

	 invoke    GetStdHandle,\ ; get handle on console input
		   STD_INPUT_HANDLE

	 mov	   [hIn],eax

match =yes, USE_BB_FILE {
	 cinvoke      open,\
		      filename,\
		      O_RDWR+O_CREAT+O_BINARY,\
		      S_IWRITE+S_IREAD

	 cmp	      eax,-1
	 jz	 near EndCommand_quick_

	 mov	      [fd],eax

	 cinvoke      read,\
		      [fd],\
		      dwXOffset,\
		      16
	 }

	 argsLoop_:
		call near GetNextArg_
		inc	  ebx ; Assume there is a slash here

		mov  byte dl,[ebx] ; approximate algorithm for getting
		or	  dl,$20   ; uppercase value

		xor	  edi,edi ; Setup registers before looping to
		mov	  cx,jumpChar.size ; find the right case

		LabelLoop_:
			cmp   byte dl,[jumpChar+edi] ; loop to get the
			je    near ChooseJump_	     ; associated label
			inc	   edi
			loopw	   LabelLoop_
			jmp   near argsLoop_

				Color_:
				       call    near GetNextNumber_

				       invoke	    SetConsoleTextAttribute,\ ; set the console attributes
						    [hOut],\
						    eax

				       jmp     near argsLoop_

				Key_:
				       cmp     byte [ebx+1],'_'
				       jnz     near KeyNext_

					       cinvoke	    _kbhit  ; if we use non - blocking version of /k
					       test	    eax,eax
					       jz      near argsLoop_

				       KeyNext_:
				       cinvoke	    getch   ; get the key that was hit
				       cmp	    eax,224
				       jnz     near KeyEnd_

					      cinvoke	    getch ; get extended key
					      add	   eax,255

				       KeyEnd_:
				       mov	    [status],eax
				       jmp	    EndCommand_

				Goto_:
					call	near GetNextNumber_  ; Add offsets
					add	     eax,[dwXOffset]
					mov	     [dwXLast],eax
					mov	     [p.X],ax

					call	near GetNextNumber_  ; Add offsets
					add	     eax,[dwYOffset]
					mov	     [dwYLast],eax
					mov	     [p.Y],ax

				Goto_simple_:
					invoke	     SetConsoleCursorPosition,\ ; set cursor position
						     [hOut],\
						     dword [p]

					jmp	near argsLoop_

				Char_:
					call	near GetNextNumber_
					mov    dword [pBuf],0
					mov    dword [pBuf],eax

					invoke	     printf,strMask,pBuf ; print a character

					jmp	near argsLoop_

				Disp_:
					call	near GetNextArg_
					cinvoke      printf,strMask,ebx
					jmp	near argsLoop_

				Mouse_:
					call	near GetMouseInput_ ; get input informations

					test	     [input.dwEventFlags],EVENT_CLICK_MASK
					jnz	near Mouse_
					mov	     eax,[input.dwButtonState]
					test	     eax,eax
					jz	near Mouse_
					call	near PrintMouseCoord_

					jmp	near argsLoop_

				Position_:
					call	near GetMouseInput_ ; get input informations

					call	near PrintMouseCoord_

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

				Hide_:
					invoke	     GetConsoleCursorInfo,[hOut],cursorInfo
					call	near GetNextNumber_
					mov	     [cursorInfo.bVisible],eax
					invoke	     SetConsoleCursorInfo,[hOut],cursorInfo
					jmp	near argsLoop_

				HideConsole_:
					call	near GetNextNumber_
					mov	     edi,eax
					invoke	     GetConsoleWindow
					invoke	     ShowWindow,\
						     eax,\
						     edi
					jmp	near argsLoop_

				NewLine_:
					inc	     [dwYLast]
					mov	     eax,[dwXLast]
					mov	     [p.X],ax
					mov	     eax,[dwYLast]
					mov	     [p.Y],ax
					jmp	near Goto_simple_


				Sprite_:
match =yes, USE_X_OPTION {
					call	near GetNextArg_

					cinvoke      open,\ ; open the file containing
						     ebx,\  ; the sprite
						     O_RDONLY+O_BINARY,\
						     0

					cmp	     eax,-1
					jz	near argsLoop_

					mov	     [fd2],eax

					call	near GetNextNumber_
					mov	     [p.X],ax

					call	near GetNextNumber_
					mov	     [p.Y],ax

					; read the dimensions of the actual file
					cinvoke      read,\
						     [fd2],\
						     dim,\
						     4

					mov	     ax,[dim.X]
					mov	     cx,[dim.Y]
					mul	     cx ; compute the size of the actual buffer (X*Y)

					mov	     si,dx
					shl	     esi,16
					mov	     si,ax ; put the result of mul (DX:AX) in ecx.

					cmp	     esi,$2fffffff ; Check wether we wil overflow
					; when ecx will be multiplied by 4 to get the bytes to malloc
					jg	near Sprite_Close_ ; fool, we'll overflow !

						shl	     esi,2


						cinvoke      malloc,\
							     esi

						test	     eax,eax ; exit if we can't malloc buffer
						jz	near Sprite_Close_

						mov	     [bin],eax

						cinvoke      read,\ ; read bytes in the file
							     [fd2],\
							     [bin],\
							     esi

						cmp	     esi,eax ;check if we read the right
						jnz	near Sprite_Skip_Render_ ; number of bytes

							; initialize the small_rect structure

							mov	  eax,[p]
							mov	  [rect],eax
							add	  eax,[dim] ; this is faulty yeah !
							; What if either  either X or Y overflow ?
							; however, i keep this because tests have proven
							; it does not affect anything.
							mov	  [rect+4],eax



							invoke WriteConsoleOutput,\
							       [hOut],\
							       [bin],\ ; character buffer !
							       [dim],\ ; dimension of buffer !
							       0,\   ; position of buffer !
							       rect

						Sprite_Skip_Render_:

						cinvoke      free,\
							     [bin]

					Sprite_Close_:

					cinvoke       close,\
						     [fd2]

					jmp	near argsLoop_
}

GetMouseInput_:
	invoke	     SetConsoleMode,\ ;set the console mode
		     [hIn],\
		     0x0018 ;ENABLE_WINDOW_INPUT | ENABLE_MOUSE_INPUT

	invoke	     ReadConsoleInput,\ ; get console input
		     [hIn],\
		     input,\
		     1,\		; number of input to read
		     bin

	cmp	     [bin],0
	jz	near GetMouseInput_
	cmp	     [input.EventType],EVENT_TYPE_MOUSE
	jne	near GetMouseInput_
	ret

PrintMouseCoord_:
	mov	     edi,[input.dwMousePosition]
	mov	     esi,edi
	shr	     edi,16
	and	     esi,COORD_MASK
	add	     eax,[input.dwEventFlags]

	cinvoke      printf,\
		     mouseMask,\
		     esi,\
		     edi,\
		     eax
	ret

GetNextNumber_:
	; Get a number for the command line
	call	 near GetNextArg_
	cinvoke       strtol,\
		      ebx,\
		      0,\
		      0
	ret

ChooseJump_:
	; jump to the appriorate
	jmp	near [jumpTable+edi*4]

GetNextArg_:
	add	     [argv],4
	mov	     ebx,[argv]
	mov	     ebx,[ebx]
	test	     ebx,ebx
	jz	near EndCommand_
	ret

EndCommand_:
match =yes, USE_BB_FILE {
	cinvoke       chsize,\
		      [fd],\
		      0

	cinvoke       write,\
		      [fd],\
		      dwXOffset,\
		      16

	cinvoke       close,\
		      [fd]
	}

EndCommand_quick_:
	cinvoke       exit,[status]

strMask      db '%s',0
mouseMask    db '%d:%d:%d',$0A,0

dwXOffset    dd 0
dwYOffset    dd 0
dwXLast      dd 0
dwYLast      dd 0
pBuf	     db 0,0,0,0,0

match =yes, USE_X_OPTION {
jumpTable    dd Key_,Goto_,Char_,Color_,Disp_,Mouse_,Offset_,Wait_,Hide_,HideConsole_,Position_,NewLine_,Sprite_
jumpChar     db 'kgacdmowhpynx'
}
match =no, USE_X_OPTION {
jumpTable    dd Key_,Goto_,Char_,Color_,Disp_,Mouse_,Offset_,Wait_,Hide_,HideConsole_,Position_,NewLine_
jumpChar     db 'kgacdmowhpyn'
}

filename     db '.bb',0
status	     dd 0

data import
 library msvcrt,'MSVCRT.DLL',\
	 kernel,'KERNEL32.DLL',\
	 user,'USER32.DLL'

 import user,\
	ShowWindow,'ShowWindow'

match =yes, USE_X_OPTION {
	import kernel,\
	GetStdHandle,'GetStdHandle',\
	SetConsoleMode,'SetConsoleMode',\
	SetConsoleTextAttribute,'SetConsoleTextAttribute',\
	SetConsoleCursorPosition,'SetConsoleCursorPosition',\
	ReadConsoleInput,'ReadConsoleInputA',\
	Sleep,'Sleep',\
	SetConsoleCursorInfo,'SetConsoleCursorInfo',\
	GetConsoleCursorInfo,'GetConsoleCursorInfo',\
	GetConsoleWindow,'GetConsoleWindow',\
	WriteConsoleOutput,'WriteConsoleOutputW'
}

match =no, USE_X_OPTION {
	import kernel,\
	GetStdHandle,'GetStdHandle',\
	SetConsoleMode,'SetConsoleMode',\
	SetConsoleTextAttribute,'SetConsoleTextAttribute',\
	SetConsoleCursorPosition,'SetConsoleCursorPosition',\
	ReadConsoleInput,'ReadConsoleInputA',\
	Sleep,'Sleep',\
	SetConsoleCursorInfo,'SetConsoleCursorInfo',\
	GetConsoleCursorInfo,'GetConsoleCursorInfo',\
	GetConsoleWindow,'GetConsoleWindow'
}

match =yes, USE_BB_FILE {

 import msvcrt,\
	printf, 'printf',\
	getch,'_getch',\
	__getmainargs,'__getmainargs',\
	exit,'exit',\
	_kbhit,'_kbhit',\
	strtol,'strtol',\
	open,'_open',\
	write,'_write',\
	read,'_read',\
	close,'_close',\
	chsize,'_chsize',\
	malloc,'malloc',\
	free,'free'

}

match =no, USE_BB_FILE {
 import msvcrt,\
	printf, 'printf',\
	getch,'_getch',\
	__getmainargs,'__getmainargs',\
	exit,'exit',\
	_kbhit,'_kbhit',\
	strtol,'strtol'
}

end data

argc	    dd	  ?
argv	    dd	  ?
hIn	    dd	  ?
hOut	    dd	  ?
bin	    dd	  ?
p	    COORD ?
input	    INPUT_RECORD ?
cursorInfo  CONSOLE_CURSOR_INFO ?

match =yes, USE_BB_FILE {
fd	    dd ?
}

match =yes, USE_X_OPTION {
fd2	    dd ?
dim	    COORD  ?
rect	    SMALL_RECT ?
}