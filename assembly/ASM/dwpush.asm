assume cs:code

; 将 dw 中的数据 位置交换
code segment

				dw 0123H,0456H,0789H,0ABCH,0DEFH,0FEDH,0CBAH,0987H  ; 将内存中的这一段当做数据

				dw 0,0,0,0,0,0,0,0									; 将内存中的这一段当做栈
				dw 0,0,0,0,0,0,0,0 									; 一个dw或者db 将另起一段16字节偏移

start:			mov ax,cs
				mov ss,ax
				mov sp,48

				mov bx,0
				mov cx,8
pushData:    	push cs:[bx]
				inc bx
				inc bx
				loop pushData

				mov bx,0
				mov cx,8
popData: 		pop cs:[bx]
				inc bx
				inc bx
				loop popData

				mov ax,4c00H
				int 21H
code ends

end start