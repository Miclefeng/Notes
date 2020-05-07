assume cs:code

; 向内存0:200 ~ 0:23F 依次写入 0 ~ 3FH(63) 的数据
code segment
				mov ax,20H
				mov es,ax

				mov bx,0
				mov cx,64

setNumber:		mov es:[bx],bl  ; bx 设置为0，bl 也为 0 
				inc bx			; bx 增加，bl 中的值也增加， bx 中的值 = bl 中的值
				loop setNumber

				mov ax,4c00H
				int 21H
code ends

end