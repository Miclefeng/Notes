assume cs:code,ss:stack


data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	; 以上是表示 21 年
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	; 以上表示 21 年的总收入
	dw 3,7,9,13,28,38,130,22,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	; 以上是 21 年的公司雇员人数
data ends


table segment
	db 21 dup('year summ ne ?? ')
table ends


stack segment stack
	db 128 dup(0)
stack ends


code segment
start:			mov ax,data
				mov ds,ax
				mov ax,table
				mov es,ax

				mov bx,0
				mov si,0		; 年份和收入都是 4 字节,用 si 记录偏移
				mov di,21*4*2	; 员工人数 2 个字节,用 di 记录偏移
				mov cx,21			

average:		push ds:[si] 	; CPU 不能直接内存到内存操作，因为CPU只能读或写 不能同时写，所有借助栈暂存内存中的数据
				pop es:[bx]
				push ds:[si+2]
				pop es:[bx+2]	; 复制年份

				push ds:[si+21*4]
				pop es:[bx+5]
				push ds:[si+21*4+2]
				pop es:[bx+7]	; 复制收入

				push ds:[di]
				pop es:[bx+10]	; 复制雇员
					
				mov ax,ds:[si+21*4]		; 将被除数低位放到AX中
				mov dx,ds:[si+21*4+2]   ; 将被除数高位放到DX中
				div word ptr ds:[di] 	; 除数 ds:[di]
				mov es:[bx+13],ax		; 将商放到内存es:[bx+13]中

				add si,4
				add di,2
				add bx,16
				loop average

				mov ax,4c00h
				int 21h
code ends


end start