assume cs:code,ds:data

; 将 data 段中的字符 首字母转换为大写
data segment
	db '1. file         ' ; 字符串分配一个段长度 16byte
	db '2. edit         '
	db '3. search       '
	db '4. view         '
	db '5. options      '
	db '6. help         '
data ends


code segment
start:			mov ax,data
				mov ds,ax

				mov bx,0
				mov cx,6
ucfirst:		mov al,ds:[bx+3]
				and al,11011111B   ; 转大写就是将第 5 为设为0
				mov ds:[bx+3],al
				add bx,16
				loop ucfirst

				mov ax,4c00h
				int 21h
code ends

end start