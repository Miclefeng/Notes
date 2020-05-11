assume cs:code,ss:stack,ds:data


stack segment stack
	db 128 dup(0)
stack ends


data segment
	db	'1) restart pc ',0
	db	'2) start system ',0
	db	'3) show clock ',0
	db	'4) set clock ',0
	dw 	0,0fh,20h,2fh
data ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				call InitReg

				call ShowString

				; mov si,0fh
				; mov di,160*11+32*2
				; call ShowString

				; mov si,20h
				; mov di,160*12+32*2
				; call ShowString

				; mov si,2fh
				; mov di,160*13+32*2
				; call ShowString

				mov ax,4c00h
				int 21h
;=====================================
InitReg:		
				mov ax,data
				mov ds,ax

				mov ax,0B800H
				mov es,ax

				ret

;=====================================
ShowString:		
				mov bx,3dh
				mov di,160*10+32*2
				mov cx,4
show_rows:		mov si,ds:[bx]			; 外部循环用 栈 暂存公用的 寄存器
				push cx
				push di
				push si
				call show_string
				add bx,2
				pop si
				pop di
				add di,160
				pop cx
				loop show_rows
				ret

;=====================================
show_string:	
				mov cx,0
inner_loop:		mov cl,ds:[si]
				jcxz show_string_ret
				mov es:[di],cl
				inc si
				add di,2
				jmp inner_loop

show_string_ret:
				ret

code ends


end start