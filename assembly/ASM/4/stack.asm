assume cs:code

code segment
				mov ax,2000H 				;AX = 2000H
				mov ss,ax   				;SS = 2000H
				mov sp,0 					;SP = 0H
				add sp,10H 					;SP = 10H
				pop ax 						;
				pop bx
				push ax
				push bx
				pop ax
				pop bx


				mov ax,4c00H
				int 21H

code ends

end