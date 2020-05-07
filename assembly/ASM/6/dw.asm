assume cs:code


code segment

				dw 1,2,3,4,5,6,7,8   ; 自定义的数据段，不是指令，位置也会存在 cs:ip 指向的内存地址

start:			mov bx,0
				mov ax,0
				mov cx,8

addNumber: 		add ax,cs:[bx]
				inc bx
				inc bx
				loop addNumber

				mov ax,4c00H
				int 21H
code ends

end start ; end 通知编译器程序结束，也标记程序的入口位置，指明了程序入口在 start 处 
