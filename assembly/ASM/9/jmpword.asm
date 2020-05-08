assume cs:code


code segment
start:			mov ax,0123h
				mov bx,0
				mov ds:[bx],ax
				mov word ptr ds:[bx+2],0 ; 向内存中写值，必须指定size， byte ptr 、 word ptr
				;jmp word ptr ds:[bx] ; IP = 0123H
				jmp dword ptr ds:[0]  ; CS:IP = 0000:0123H

				mov ax,4c00h
				int 21h
code ends

end start