assume cs:code

; 将 FFFF:0 ~ FFFF:F 内存单元中的值复制到 0:200 ~ 0:20F 中
; ds 寄存器，取数据(数据来源) ， es 寄存器，存数据(数据去向)
code segment
	
			mov ax,0ffffH
			mov ds,ax

			mov ax,20H
			mov es,ax

			mov bx,0
			mov cx,8

setNumber:	;mov dx,ds:[bx]
			;mov es:[bx],dx
			push ds:[bx]   ; 可以用栈代替，节省寄存器
			pop es:[bx]
			inc bx
			inc bx

			loop setNumber

			mov ax,4c00H
			int 21H
code ends

end