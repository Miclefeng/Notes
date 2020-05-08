assume cs:code,ss:stack


stack segment stack
	db 16 dup(0)
stack ends


code segment
				mov ax,4c00h
				int 21h

start:			mov ax,stack
				mov ss,ax
				mov sp,16

				mov ax,0
;				push ax     ; 栈中的数据为 0 
;				mov bx,0
;				ret 		; 相当于 pop IP, 修改 IP 中的值，设置为 0 

				push cs
				push ax
				mov bx,0
				retf 		; 相当于 pop IP , pop CS
code ends


end start