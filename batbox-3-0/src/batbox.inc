; Copyright (c) 2014, Romain GARBI (Darkbatcher)
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
; THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
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


; some structure used by winapi calls
struct COORD
     X dw ?
     Y dw ?
ends

struct INPUT_RECORD
     EventType dw ?
     nul dw ?
     dwMousePosition COORD ?
     dwButtonState dd ?
     dwControlKeyState dd ?
     dwEventFlags dd ?
ends

struct CONSOLE_CURSOR_INFO
     dwSize dd ?
     bVisible dd ?
ends

;some defs needed by winapi calls
SND_NODEFAULT=2
SND_FILENAME=$20000
SND_ASYNC=1

EVENT_TYPE_MOUSE=2
COORD_MASK=$0000FFFF

EVENT_CLICK_MASK=$FFFFFFFD ; ~MOUSE_DOUBLE_CLICK

ERROR_PIPE_CONNECTED=535

;redefine db to get the size constant
struc db [data]
{
	common
	. db data
	.size = $ - .
}