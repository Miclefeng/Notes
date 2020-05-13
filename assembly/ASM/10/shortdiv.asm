assume cs:code,ds:data,ss:stack


stack segment stack
	db 128 dup(0)
stack ends


data segment
	dw 1234
data ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				call InitReg

				mov si,0
				mov di,160*10+40*2

				mov ax,ds:[si]			; 16位除法,AX 保存商
 				mov dx,0				; DX 保存余数

 				call ShortDiv

 				mov ax,4c00h
 				int 21h

ShortDiv:
				mov cx,10
				div cx

				add dl,30h				; ASCII 码的数字值 比数字多 30h
				mov es:[di+0],dl
				mov byte ptr es:[di+1],01001010B
				mov cx,ax
				jcxz shortDivRet
				sub di,2
				mov dx,0
				jmp ShortDiv
				ret

shortDivRet:	ret

InitReg:		
				mov ax,data
				mov ds,ax

				mov bx,0B800H
				mov es,bx

				ret

code ends


end start