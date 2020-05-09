assume cs:code,ds:data


; stack segment stack
; 	dw 8 dup(0)
; stack ends


data segment
	dw 8 dup(0)
data ends


code segment
start:			mov ax,data
				mov ss,ax
				mov sp,16
				; mov ds,ax
				; mov ax,0
				; call word ptr ds:[0EH]
				; inc ax
				; inc ax
				; inc ax
				mov word ptr ss:[0],offset s
				mov ss:[2],cs
				call dword ptr ss:[0]
				nop
s:				mov ax,offset s
				sub ax,ss:[0CH]
				mov bx,cs
				sub bx,ss:[0EH]

				mov ax,4c00h
				int 21h
code ends


end start