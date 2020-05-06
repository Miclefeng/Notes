assume cs:code,ds:data


; 将 data 段的第一行转为大写，第二行转为小写
data segment
	db 'BaSic'			; 同一个段内，多个db 定义的字节是连续的，多个段是按 16byte 字节对齐的
	db 'iNfOrMaTiOn'
data ends

code segment
start:			mov ax,data
				mov ds,ax

				mov bx,0
				mov cx,5
upper:			mov al,ds:[bx]			; 字符转大写，将 第5位设为0即可
				and al,11011111B
				mov ds:[bx],al
				inc bx
				loop upper

				mov bx,5
				mov cx,11
lower:			mov al,ds:[bx] 			; 字符转小写，将 第5位设为1即可
				or 	al,00100000B
				mov ds:[bx],al
				inc bx
				loop lower

				mov ax,4c00h
				int 21h
code ends

end start