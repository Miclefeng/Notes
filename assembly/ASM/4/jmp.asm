assume cs:code


code segment

			mov ax,2000H
			mov ds,ax
			mov bx,1000H
			mov dl,0

setNumber:	mov ds:[bx],dl
			inc dl
			inc bx
; jmp  跳转指令，修改CPU中 IP 寄存器的值
			jmp setNumber    ; 设置标识(内存地址)

code ends

end