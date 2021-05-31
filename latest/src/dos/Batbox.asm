org 100h

FOR_RED=$4
FOR_BLUE=$1
FOR_GREEN=$2
BACK_BLUE=$10
BACK_GREEN=$20
BACK_RED=$40
BLINK=$80
INTENSITY=$8



mov	ah,FOR_BLUE
call	BatBox_ScreenInit
mov	ah,09
mov	dx,lpEnter
int	21h
mov	cx,30
Print:
	mov	si,lpMsg2
	mov	[iAttr],cl
	call	BatBox_Puts
	loop Print
mov	ch,10
Print1:
	mov	si,lpMsg
	mov	[iAttr],ch
	call	BatBox_Puts
	loop Print1

mov	ax,4C00h
int	21h



lpEnter db $0d,$0a, $0d,$0a, $0d,$0a, $0d,$0a, $0d,$0a, $0d,$0a, '$'
lpMsg db "hello world!",$0d,0
lpMsg2 db "bye world!",$0d,0


; args : ax -> text attribute
BatBox_ScreenInit:
	mov [lpPointer],0h
	mov [iLine],0h
	mov [iAttr],ah
	mov ax,03h
	int 10h
	ret


BatBox_Puts:
	push $b800
	pop  es
	mov  di,[lpPointer]
	__Puts_Loop:
		cmp byte [ds:si],$0d
		jnz __Puts_Next
		    inc [iLine]
		    mov al,160
		    mul byte [iLine]
		    mov di,ax
		    inc si
		__Puts_Next:
		cmp byte [ds:si],$0
		jz __Puts_Loop_End
		cmp di,25*80*2
		jb __Puts_Not_Zero
		    xor di,di
		__Puts_Not_Zero:
		movsb
		mov al,[iAttr]	 ; bgri bgr blink
		stosb
		jmp __Puts_Loop
       __Puts_Loop_End:
       mov [lpPointer],di
       ret

BatBox_Cls:

lpPointer dw ?
iLine	  db ?
iAttr	  db ?