assume cs:code,ss:stack,ds:data


stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends


data segment
	db '1. display      '
	db '2. brows        '
	db '3. replase      '
	db '4. modify       '
data ends


code segment
start:			mov ax,data
				mov ds,ax

				mov bx,0
				mov cx,4

loopTimes:		push cx
				mov si,3
				mov cx,4

upper:			mov al,ds:[bx+si]		; bx 作为基础地址
				and al,11011111B
				mov ds:[bx+si],al
				inc si
				loop upper

				add bx,16
				pop cx
				loop loopTimes

				mov ax,4c00h
				int 21h
code ends


end start