assume cs:code,ss:stack,ds:data


stack segment stack
	db 128 dup(0)
stack ends


data segment
	db 	'welcome to masm!'
	db 	00000010B 			; 绿色
	db 	01001010B			; 红底绿字
	db 	01110001B			; 白底蓝字
data ends


code segment
start:			mov ax,stack	; 栈段和数据段分开设置
				mov ss,ax
				mov sp,128

				call InitReg

				mov si,0
				mov di,160*10+32*2
				mov bx,16
				mov dx,0
				call ShowMasm

				mov ax,4c00h
				int 21h
;=====================================
InitReg:		mov ax,data
				mov ds,ax

				mov ax,0B800H
				mov es,ax
				ret
;======================================
ShowMasm:		mov cx,3
				
show_line:		push cx
				push di
				push si
				mov cx,16
				mov dh,ds:[bx]

show_masm:		mov dl,ds:[si]
				mov es:[di],dx
				inc si
				add di,2
				loop show_masm

				inc bx
				pop si
				pop di
				add di,160
				pop cx
				loop show_line
				ret
code ends


end start