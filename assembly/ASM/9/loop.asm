assume cs:code


code segment
start:			mov ax,2000h
				mov ds,ax
				mov bx,0

s:				mov cl,ds:[bx]
				mov ch,0
				inc cx   ; 取出来 cx=0 的话，(CX)-1 = FFFFH 所以得先自增 1 
				inc bx
				loop s 	 ; loop 标号 先进行 (CX)-1 , 在进行判断 (CX)!=0 jmp short 标号处
ok:				dec bx	 ; 将额外的一次自增 自减掉
				mov dx,bx

				mov ax,4c00h
				int 21h
code ends


end start