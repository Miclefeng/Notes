assume cs:code,ds:data


data segment
		;0123456789AB
	db 	'conversation'
data ends


code segment
start:			mov ax,data
				mov ds,ax

				mov si,0		; 用SI寄存器记录内存数据的起始地址
				mov cx,12		; 用CX寄存器记录内存中数据的长度
				call capital

				mov ax,4c00h
				int 21h
; 子程序，将内存中的数据转为大写
capital:		and byte ptr ds:[si],11011111B ;使用内存中的数据需要指明大小
				inc si
				loop capital
				ret
code ends


end start