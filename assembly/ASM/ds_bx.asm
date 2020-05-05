assume cs:code

code segment


			mov bx,10H
			mov ax,ds:[bx]

			add bx,2
			mov ax,ds:[bx]

			add bx,1
			mov al,ds:[bx]

			mov ax,4c00H
			int 21H
code ends

end