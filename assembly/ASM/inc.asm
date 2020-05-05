assume cs:code

code segment

			mov ax,2000H
			mov ds,ax 			;ds = 2000H
			mov bx,1000H        ;bx = 1000H
			mov dl,0beH         ;dl = beH
			mov ds:[bx],dl 		;ds:[1000H] = be

			mov ax,ds:[bx] 		;ax = 00be
			
			inc bx 				;bx = 2000H + 1 = 2001H
			inc bx              ;bx = 2001H + 1 = 2002H
			mov ds:[bx],ax
			
			inc bx
			inc bx
			mov ds:[bx],ax

			inc bx
			mov ds:[bx],al

			inc bx
			mov ds:[bx],al

code ends

end
