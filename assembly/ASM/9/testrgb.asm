assume cs:code,ss:stack,ds:data


stack segment stack
	db 128 dup(0)
stack ends


data segment
	   	;0123456789ABCDEF
	db 	'welcome to masm!'
	db 	00000010B			; 绿色
	db	01001010B			; 红底高亮绿色
	db 	01110001B			; 白底蓝色
data ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				mov ax,data 		; 数据来源 读取内存地址
				mov ds,ax

				mov ax,0B800H 		; 数据取出 写入内存地址
				mov es,ax

				mov bx,16		 	; 颜色偏移
				mov di,160*10+32*2	; 一屏25x80，写在第10行，32个字符出
				mov cx,3

lines:			push cx
				push di		 		; 暂存 di 的偏移，使其都是以 160xN+32*2 位置处开始，下面 es:[di] 改变了 di 的初始值，所有用栈暂存初始值
				mov cx,16
				mov dx,0
				mov si,0 			; 写入字符偏移

showRow:		mov dl,ds:[si]		; 低地址存 ASCII码
				mov dh,ds:[bx]		; 高地址存 字体属性(颜色)
				mov es:[di],dx

				inc si
				add di,2
				loop showRow

				inc bx
				pop di
				add di,160
				pop cx
				loop lines

				mov ax,4c00h
				int 21h
code ends


end start