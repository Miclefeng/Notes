assume cs:code,ss:stack


stack segment stack
	db 128 dup(0)
stack ends


data segment
	; 表示 21 年
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	
	; 表示 21 年的总收入
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	
	; 21 年的公司雇员人数
	dw 3,7,9,13,28,38,130,22,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends


table segment
			  ;0123456789ABCDEF
	db 21 dup('year summ ne ?? ')
table ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				call ClearScreen

				call InputTable

				call OutputTable


				mov ax,4c00h
				int 21h

;=========================================================
OutputTable:
				mov bx,table
				mov ds,bx
				mov si,0

				mov bx,0b800h
				mov es,bx
				mov di,160*3

				mov cx,14

output_table:	call showYear

				call showIncome

				call showNe

				call showAverage
				
				add si,16
				add di,160
				loop output_table

				ret			

;=========================================================
showAverage:		
				push cx
				push ax
				push bx
				push dx
				push si
				push di
				push ds
				push es

				add di,70
				mov ax,ds:[si+13]
				mov dx,0

				call shortDiv

				pop es
				pop ds
				pop di
				pop si
				pop dx
				pop bx
				pop ax
				pop cx

				ret					

;=========================================================
showNe:		
				push cx
				push ax
				push bx
				push dx
				push si
				push di
				push ds
				push es

				add di,50
				mov ax,ds:[si+10]
				mov dx,0

				call shortDiv

				pop es
				pop ds
				pop di
				pop si
				pop dx
				pop bx
				pop ax
				pop cx

				ret

;=========================================================
showIncome:		
				push cx
				push ax
				push bx
				push dx
				push si
				push di
				push ds
				push es

				add di,30
				mov ax,ds:[si+5]
				mov dx,ds:[si+7]

				call shortDiv

				pop es
				pop ds
				pop di
				pop si
				pop dx
				pop bx
				pop ax
				pop cx

				ret

;=========================================================
shortDiv:		mov cx,10
				div cx

				add dl,30h
				mov es:[di],dl
				mov cx,ax
				jcxz short_div_ret
				mov dx,0
				sub di,2
				jmp shortDiv

short_div_ret:	ret

;=========================================================
showYear:
				push cx
				push ax
				push bx
				push dx
				push si
				push di
				push ds
				push es

				add di,6
				mov cx,4

show_year:		mov dl,ds:[si]
				mov es:[di],dl
				inc si
				add di,2
				loop show_year

				pop es
				pop ds
				pop di
				pop si
				pop dx
				pop bx
				pop ax
				pop cx

				ret

;=========================================================
InputTable:
				mov bx,data
				mov ds,bx
				mov si,0

				mov bx,table
				mov es,bx
				mov di,0

				mov bx,21*4*2
				mov cx,21

input_table:	push ds:[si]
				pop es:[di]
				push ds:[si+2]
				pop es:[di+2]

				push ds:[si+21*4]
				pop es:[di+5]
				push ds:[si+21*4+2]
				pop es:[di+7]

				push ds:[bx]
				pop es:[di+10]

				mov ax,ds:[si+21*4]
				mov dx,ds:[si+21*4+2]

				div word ptr ds:[bx]
				mov es:[di+13],ax

				add si,4
				add bx,2
				add di,16
				loop input_table

				ret

;=========================================================
ClearScreen:
				mov bx,0b800h
				mov es,bx
				mov di,0

				mov dx,0700h
				mov cx,2000

clear_screen:	mov es:[di],dx
				add di,2
				loop clear_screen

				ret

code ends


end start