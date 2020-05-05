assume cs:code

code segment

				mov ax,2000H
				mov ds,ax
				mov bx,1000H
				mov cx,16 		; cx 寄存器存放 loop 指令循环的次数，cx 的指令不能设置为 0，导致 0-1 = FFFF，内存溢出，loop 指令执行超出正常次数 

				mov dl,0

setNumber:		mov ds:[bx],dl
				inc dl
				inc bx

				loop setNumber

				mov ax,4c00H
				int 21H
code ends

end