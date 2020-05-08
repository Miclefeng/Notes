assume cs:code,ds:data,ss:stack


; 内存地址空间中，B8000H ~ BFFFFH 共 32KB 的空间
; 为 80x25(一页屏幕有25行，每一行有80个字符，160个字节) 
; 彩色字符模式的显示缓冲区。向这个地址空间写入数据，写入的内容将立即出现在显示器上
; ASCII 码
; 100H 102H 104H 存放字符的 ASCII码
; 101H 103H 105H 存放字符的颜色
; 偶数地址 都是存放 字符的 ASCII码
; 奇数地址 都是存放 字符的颜色(字符的属性)
; 这样，一个字符在显示缓冲区中就要占用两个字节，分别存放字符的 ASCII码和属性。
; 7 6 5 4 	3 2 1 0
;	r g b     r g b
; 背景		前景
; 背景 = 底色
; 前景 = 字体颜色
; 7 闪烁，3 高亮， r = red, g = green,  b = blue 
; 红底绿字：  	0100 0010B
; 红底高亮绿字：	0100 1010B
stack segment stack
	db 128 dup(0)
stack ends


data segment
			;0123456789ABCDEF
	db 		'welcome to masm!'
	db		00000010B			; 绿色
	db 		00100100B			; 绿底红色
	db 		01110001B			; 白底蓝色
data ends


code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128

				mov ax,data
				mov ds,ax

				mov ax,0B800H		; 数据写入用 es 寄存器存储要写入数据的内存地址
				mov es,ax

				mov di,160*10+32*2	; 一行80个字符，160字节 str有16字节，中间位置起始位 80-8*2=64
				mov bx,16			; 颜色的偏移位置
				mov dx,0

				mov cx,3
line:			push cx
				push di				; di 每行数据，递增160 需要暂存上一次的偏移数据
				mov si,0
		
				mov cx,16
				mov dh,ds:[bx]		; 高地址存颜色
showString:		mov dl,ds:[si] 		; 低地址存字符
				mov es:[di],dx		; 以字的方式写入内存单元
				inc si
				add di,2			
				loop showString 
				pop di
				add di,160
				inc bx
				pop cx
				loop line

				mov ax,4c00h
				int 21h
code ends

end start