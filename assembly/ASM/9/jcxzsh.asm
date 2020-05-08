assume cs:code


code segment
start:			mov ax,2000H
				mov ds,ax
				mov bx,0

s:				mov cl,ds:[bx]
				mov ch,0
				jcxz ok 	; 当cx=0时，跳转到标号处
				inc bx			

				jmp short s

ok:				mov dx,bx

				mov ax,4c00h
				int 21h
code ends


end start