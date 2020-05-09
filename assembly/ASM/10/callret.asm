assume cs:code


code segment
start:			mov ax,1
				mov cx,3		; 内存地址	  机器码 低位 高位
				call s 			; 076A:0006		E8   07  00 
								;                    0070 16位位移，即用 s 标号处的地址(0010H) - call 指令后面第一个字节的地址(0009H)
				mov bx,ax		; 076A:0009

				mov ax,4c00h
				int 21h

s:				add ax,ax		; 076A:0010		
				loop s
				ret
code ends


end start