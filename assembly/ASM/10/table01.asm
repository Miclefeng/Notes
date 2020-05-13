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
	db 21 dup('year summ ne ?? ')
table ends


string segment
	db 10 dup('0'),0
string ends

code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				call InitReg
				
				call ClearScreen

				call InputTable

				call OutputTable

				mov ax,4c00h
				int 21h

;========================================
OutputTable:
				call init_reg_output_table
				
				mov si,0
				mov di,160*3+16

				mov cx,21

output_table:	call showYear
				add si,16
				add di,160
				loop output_table

				ret

;========================================
showYear:		
				push cx
				push si
				push di
				push ds
				push es
				mov bx,0b800h
				mov es,bx
				mov cx,4

show_year:		mov al,ds:[si]
				mov es:[di],al
				inc si
				add di,2
				loop show_year
				pop es
				pop ds
				pop di
				pop si
				pop cx
				ret

;========================================
init_reg_output_table:
				mov bx,table
				mov ds,bx

				mov bx,string
				mov es,bx

				ret

;========================================
ClearScreen:
				mov bx,0
				mov dx,0700h
				mov cx,2000

clear_screen:	mov es:[bx],dx
				add bx,2
				loop clear_screen

				ret

;========================================
InputTable:		
				call init_reg_input_table
				
				mov bx,0
				mov si,0
				mov di,21*4*2
				mov cx,21

input_table:	push ds:[si]			; CPU 不能直接操作内存到内存，只能读或写，不能同时读写，可以用栈寄存器暂存读取的数据在写入内存
				pop es:[bx]
				push ds:[si+2]
				pop es:[bx+2]

				push ds:[si+21*4]
				pop es:[bx+5]
				push ds:[si+21*4+2]
				pop es:[bx+7]

				push ds:[di]
				pop es:[bx+10]

				mov ax,ds:[si+21*4]		; 16位除法，ax保存低16位被除数，dx保存高16位被除数
				mov dx,ds:[si+21*4+2]
				div word ptr ds:[di]
				mov es:[bx+13],ax

				add bx,16
				add si,4
				add di,2
				loop input_table

				ret

;========================================
init_reg_input_table:
				mov bx,data
				mov ds,bx

				mov bx,table
				mov es,bx

				ret

;========================================
InitReg:
				mov bx,0B800h
				mov es,bx

				mov bx,data
				mov ds,bx

				ret


code ends


end start