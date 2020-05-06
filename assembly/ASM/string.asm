assume cs:code,ds:data

data segment
	db 'unIX' ; 字符串 ascii 码是  75h,6eh,49h,58h
	db 'foRK'
data ends

code segment
start: 			mov ax,data
				mov ds,ax

				mov al,'a'
				mov bl,'b'
				
				mov ax,4c00h
				int 21h
code ends

end start