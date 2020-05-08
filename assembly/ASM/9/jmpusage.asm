assume cs:code


code segment 					;   内存位置	  机器码
				mov ax,4c00h	; 076A:0000   
				int 21h

start:			mov ax,0
s:				nop				; 076A:0008   90	
				nop

				mov di,offset s ; 076A:000A
				mov si,offset s2
				mov ax,cs:[si]
				mov cs:[di],ax  ; 将 EBF6 写到 s 标号处， 076A:0008 EBF6 ， EBF6 是jmp短转移 跳转指令 根据位位移来跳转, F6(-10) 是位位移 =标号地址 - jmp 下一个指令的地址(000A) 所以 标号地址就等于 0000  

s0:				jmp short s 	; 076A:0016  EBF0

s1:				mov ax,0
				int 21h
				mov ax,0

s2:				jmp short s1 	; 076A:0020  EBF6 
				nop

code ends


end start