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


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				call InputTable

				call OutputTable

				mov ax,4c00h
				int 21h

;========================================
InputTable:		
				mov ax,data
				mov ds,ax

				mov ax,table
				mov es,ax
				mov bx,0
				mov cx,21
				mov si,0
				mov di,21*4*2
input_table:
				push ds:[si]			; CPU 不能直接操作内存到内存，只能读或写，不能同时读写，可以用栈寄存器暂存读取的数据在写入内存
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
				add si,4
				add di,2
				add bx,16
				loop input_table
				ret

;========================================



code ends


end start