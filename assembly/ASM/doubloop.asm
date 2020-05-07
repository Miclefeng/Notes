; /usr/local/bin/nasm -f macho64 hello.asm && ld -macosx_version_min 10.7.0 -o hello hello.o && ./hello

assume cs:code,ds:data,ss:stack


; 将data段中的字符全部转换为大写
data segment
	db 'ibm             '
	db 'dec             '
	db 'dos             '
	db 'vax             '
data ends


stack segment stack
	dw 0,0,0,0,0,0,0,0
stack ends


code segment
start:			mov ax,data
				mov ds,ax

				mov bx,0
				mov cx,4
loopTimes:		push cx 				; 使用 dx 占用寄存器，临时暂存的数据都应该使用 栈 来实现
				; mov dx,cx 			; 将外层循环次数保存到 dx 中
				mov si,0 				; 外层循环确定次数，重置每个段的 si 和 内部循环次数
				mov cx,3

upper:			mov al,ds:[bx+si] 		; 内层循环将字符转为大写
				and al,11011111B
				mov ds:[bx+si],al
				inc si
				loop upper

				add bx,16
				pop cx
				; mov cx,dx 			; 用dx中的值恢复外层循环cx的值
				loop loopTimes

				mov ax,4c00h
				int 21h
code ends


end start