assume cs:code,ss:stack,ds:data


stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends


data segment
	db 'DEC'
	db 'Ken Oslen'
	dw 137
	dw 40
	db 'PDP'
data ends


code segment
start: 			mov ax,data
				mov ds,ax
				mov bx,60h

				mov word ptr ds:[bx+0ch],38
				add word ptr ds:[bx+0eh],70

				mov si,0
				mov byte ptr ds:[bx+10h+si],'V'
				inc si
				mov byte ptr ds:[bx+10h+si],'A'
				inc si
				mov byte ptr ds:[bx+10h+si],'X'

				mov ax,4c00h
				int 21h
code ends


end start