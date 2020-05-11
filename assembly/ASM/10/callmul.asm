assume cs:code,ss:stack,ds:data


stack segment stack
	db 128 dup(0)
stack ends


data segment
	dw 11,22,33,44,55,66,77,88
	dd 8 dup(0)
data ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,80h

				call InitReg

				call NumberMul

				mov ax,4c00h
				int 21h

;=======================================
InitReg:		
				mov ax,data
				mov ds,ax

				mov ax,data
				mov es,ax

				ret

;=======================================
NumberMul:		
				mov cx,8
				mov si,0
				mov di,10h
numbers:		mov bx,ds:[si]
				call get_cube
				mov es:[di+0],ax
				mov es:[di+2],dx
				add si,2
				add di,4
				loop numbers
				ret

;=======================================
get_cube:				
				mov ax,bx
				mul ax
				mul bx
				ret
code ends


end start