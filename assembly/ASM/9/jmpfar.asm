assume cs:code


code segment
start:			mov ax,0		;					偏移地址 段地址
				mov bx,0	   	;					  IP     CS
				jmp far ptr s  	; jmp 076A:010BH = EA 0B01  6A07
				db 256 dup(0)	; 汇编执行			机器码
s:				add ax,1
				inc ax

				mov ax,4c00h
				int 21h
code ends


end start