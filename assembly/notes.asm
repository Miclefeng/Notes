
;=============================================
; 第二章 寄存器 ==============================


1、数据寄存器
AX = AH + AL  16位寄存器，AX的高8位构成AH寄存器，AX的低8位构成AL寄存器   H = high, L = low
BX
CX
DX

0000 0000 ~ 1111 1111   0~ff  0~255
内存的最小单元是字节 8bit 1Byte
8086CPU 一次性可以处理2种尺寸的数据
有16根数据线，数据线的宽度决定了CPU一次性能够读取 多长的数据

字节型数据       byte 8bit - 8位寄存器
字型数据         2byte 16bit - 16位寄存器 2个字节
一个字节是字型数据的高位字节(AH,BH,CH,DH),一个字节是字型数据的低位字节(AL,BL,CL,DL)

2、在使用 mov 时，要保证 数据与寄存器之间 位数一致性
数据与寄存器之间要保证 一致性, 8位数据给8位寄存器，16位数据给16位寄存器

mov ax,93  
add al,85   ax=18
8位寄存器进行8位 运算，保存8位数据,溢出数据不会丢弃，保存到其他位置
16位寄存器进行16位 运算，保存16位数据,溢出数据不会丢弃，保存到其他位置
寄存器是互相独立的，AL就是AL，AH就是AH，不会互相影响


3、地址寄存器

段地址寄存器:偏移地址寄存器
DS              SP
ES              BP
SS              SI
CS              DI
                IP
                BX
8086CPU  16位寄存器 ，20根地址总线， 0000 0000 0000 0000 0000 ~ 1111 1111 1111 1111 1111  0~FFFFFH
地址总线的数量决定了CPU的寻址能力
地址加法器，地址的计算方式
段地址 X 16(10H) + 偏移地址 = 物理地址
段地址 X 16(10H) = 基础地质
基础地质 + 偏移地址 = 物理地址

段地址       偏移地址     物理地址
F230H*10H +   C8H       = F23C8H 

8086CPU中 在任意时刻，将 CS(段地址):IP(偏移地址) 组合出来的地址，所指向的内存单元中的内容当作指令来执行
在8086CPU 加电启动或复位后，CS和IP被设置为CS=FFFFH,IP=0000H,CPU从内存FFFF0H(第一条指令)单元中读取指令执行。
在内存中 指令和数据 是没有任何区别的，都是二进制数据。CPU只有在工作的时候才将有的信息当作指令，有的信息当作数据.

指令的执行过程
1、CPU从CS:IP 所指的内存单元读取数据，存放到指令缓冲器
2、IP = IP+所读指令的长度，从而得到下一条指令的位置
3、执行指令缓存器中的内容，回到第一步

mov 是传送指令
jmp 是转移指令 ，jmp 段地址:偏移地址 可以改变 CS:IP 的值, jmp + 寄存器 = 只修改 IP 的值

setNumber:
			jmp setNumber   ; 跳转到setNumber代码段的内存地址，即将IP寄存器中的值修改为setNumber标识的内存地址，类似 C 中的 goto

ds 段地址寄存器 访问数据用的,8086CPU自动取ds中的数据为内存单元的段地址，不支持直接将数据写入寄存器的操作，需要先将数据写入bx寄存器在写入ds中
mov bx,1000H
mov bs,bx
mov al,ds:[0] mov 移动指令， 将数据写入CPU中的al寄存器，ds为段地址，[0] 为偏移地址，读取一个字节的数据，因为 al 为 8位寄存器
mov ax,ds:[0] 一个字型数据 ax是16位寄存器

寄存器,段地址:偏移地址     物理地址   内存中的内容  
mov ax,1000H                
mov ds,ax                   
mov ax,ds:[0]               10000H      23H        ;[0]=1123H ax=1123H
mov bx,ds:[2]               10001H      11H        ;[1]=2211H cx=2211H
mov cx,ds:[1]               10002H      22H        ;[2]=6622H bx=6622H
add bx,ds:[1]                                      bx=8833H
add cx,ds:[2]                                      cx=8833H
mov bx,10H
mov al,ds[bx]   偏移地址寄存器
add bx,1
mov al,ds[bx]

3、栈
push 入栈，将16位寄存器或者内存中的 字型数据 放到栈顶标记的上面，修改栈顶标记
pop  出栈，将栈顶标记的 字型数据 放到 16位寄存器或者内存中，修改栈顶标记

栈顶标记是内存地址， 段地址和偏移地址来表示
在 8086CPU中 在任意时刻将段地址寄存器SS 和 偏移地址寄存器SP 所组合出来的内存地址作为栈顶标记
push ax 修改SP寄存器中的值 SP=SP-2，将 AX 中的字数据 放到 SS:SP 所组合出来的内存地址中去
pop bx  SS:SP 所组合出来的内存地址中的 字数据 ->BX, 修改SP寄存器中的值 SP=SP+2
16byte=8字型数据，可以进行8次操作，0000(起始地址)+10H(栈大小)
栈是有上限和下限的，栈的大小根据数据的多少去安排
SP寄存器的变化范围  0~FFFFH 65536byte=32768字型数据
SS=2000H SP=0 就是设置栈最大的空间，push 操作 SP-2=0000-0002=FFFEH，当push到32768个数据是 SP=0，在进行 push 就会覆盖原来栈中的数据
栈的作用：
    1、临时性保存数据
    2、交换数据

内存段的安全 数据段、代码(指令)段、栈段
mov指令，可以修改系统存放在内存中的重要数据或者指令导致程序崩溃，系统崩溃
(1) 向安全的内存空间写入内容，0:200 ~ 0:2FFH ，256个字节大小
(2) 使用操作系统分配给程序的内容空间，在操作系统的环境中，合法的通过操作系统获取的内存空间都是安全的，操作系统为程序分配内存的方式，一是系统加载程序时为程序分配内存空间，二是程序在执行过程中，向系统申请内存

4、程序
汇编程序源代码文件 asm
汇编语言
 (1) 汇编指令  mov add sub push 被汇编器翻译成 0101 机器指令，机器码由CPU执行
 (2) 伪指令    由汇编器执行  start 、 end 、 code segment
 (3) 符号体系  由汇编器执行  + - * /

汇编后的可执行程序里面会向系统申请一段内存，同时包含一些描述信息，系统根据这些描述系统对 寄存器 进行相关的设置

start 伪指令告诉汇编器，将我们设置的程序入口地址告诉可执行文件
code segment 告诉汇编器 指令段开始位置
code ends    告诉汇编器 指令段结束位置
data segment 告诉汇编器 data段开始位置
data ends    告诉汇编器 data段结束位置   为了分配内存

mov ax,4c00H;  int 21H; 来实现程序返回的功能
操作系统的shell程序加载可执行程序并给程序分配内存，设置CPU的CS:IP寄存器，在程序返回时将内存和寄存器返还给系统
程序的跟踪 debug + 程序名
cx = 程序的长度
p 执行 int 指令
g + IP寄存器中的值，直接执行到该内存地址的指令出
q 退出
PSP区 从 ds:0 开始的 256 个字节，其中包含程序的名称，系统加载程序到内存中，用来系统和程序进行通讯

inc 指令是将寄存器中的值自增 1 = add bx,1，不过 inc 指令只占一个字节， add bx,1 占3个字节，节约内存
dec 指令是将寄存器中的值自减 1 = sub bx,1，不过 dec 指令只占一个字节， sub bx,1 占3个字节，节约内存

loop 指令，循环指令 ，循环次数保存在 cx 寄存器中，每执行一次修改 cx 中的值减 1
loop 指令的 2 个步骤
 (1) cx = cx - 1
 (2) 判断 cx 中的值，不为 0 则跳转(jmp)到标识(setNumber内存地址)位置继续执行，等于 0 则执行下面的命令

			mov cx,16  ;执行 16 次循环
setNumber:
			loop setNumber 


7、不同的寻址方式
and  位运算 &  转大写使用 and al,11011111B 
or	 位运算 |  转小写使用 or  al,00100000B
二重循环可以使用栈进行临时保存外出循环的 cx 寄存器中的值
(1) [idata] 用一个常量表示内存地址，直接定位一个内存单元；
(2) [bx] 用一个变量边上内存地址，间接定位一个内存单元；
(3) [bx+idata] 用一个变量和常量表示地址，可以在一个起始地址的基础上用变量间接定位一个内存单元；
(4) [bx+si] 用两个变量表示地址；
(5) [bx+si+idata] 用两个变量和一个常量表示地址；

reg  (寄存器)   : ax,bx,cx,dx,sp,bp,si,di
sreg (段寄存器) : ds,ss,cs,es

8、数据处理
(1)
在8086CPU中,只有这4个寄存器(bx,si,di,bp)可以用在"[...]"中进行内存单元的寻址
bx+bp si+di 不能同时出现在 "[...]" 中
只要在"[...]"中使用寄存器 bp，而指令中没有显性地给出段地址，段地址默认在 ss 寄存器中
mov ax,[bp]   	含义： (ax)=((ss)*16+(bp)) 

(2) 机器指令处理的数据存储位置
绝大部分机器指令都是进行数据处理的指令，读取、写入、运算，机器指令只关心在执行前一刻，它将要处理的数据所在的位置，所有处理的数据可以在 3 个地方：CPU内部，内存，端口。

(3) 数据位置的表达
   1) 立即数(idata)   对于直接包含在机器指令中的数据(执行前在CPU的指令缓冲器中)，称为 立即数(idata)
   2) 寄存器          指令要处理的数据在寄存器中
   3) 段地址(SA)和偏移地址(EA)   指令要处理的数据在内存中，可用[x]的格式给出 EA，SA 在某个段寄存器中
   mov ax,[bx+si+8]  	  含义： (ax) = ((ds)*16 + (bx) + (si) + 8)
   mov ax,[bp]       	  含义： (ax) = ((ss)*16 + (bp))
   mov ax,ds:[bp]    	  含义： (ax) = ((ds)*16 + (bp))  
   mov ax,es:[bx]    	  含义： (ax) = ((es)*16 + (bx))
   mov ax,ss:[bx+si] 	  含义： (ax) = ((ss)*16 + (bx) + (si))
   mov ax,cs:[bx+si+8] 	含义： (ax) = ((cs)*16 + (bx) + (si) + 8)

(4) 指令处理数据的长度
	1) 在没有寄存器存在的情况下， 用操作符 X ptr 指明内存单元的长度, X 为 word 或 byte
	mov word ptr ds:[0],1
	inc word ptr ds:[bx]
	add word ptr ds:[bx],2
	2) push 指令只进行字操作

(5) div 指令
  div是除法指令
  1) 除数： 有 8 位和 16 位两种，在 reg 或者内存单元中 
  2) 被除数：默认放在 AX 或 DX 和 AX 中，如果除数为 8 位，被除数则为 16 位，默认放在 AX 中存放；如果除数为 16 位，被除数则为 32 位，在 DX 和 AX 中存放，DX 存放高 16 位，AX 存放低 16 位
  3) 结果： 如果除数为 8 位，则 AL 存储除法操作的商，AH 存储除法操作的余数；如果除数是 16 位，则 AX 存储除法操作的商，DX 存储除法操作的余数
  div byte ptr ds:[0]  含义  (al) = (ax) / ((ds)*16 + 0) 的商
                             (ah) = (ax) / ((ds)*16 + 0) 的余数  
  div word ptr es:[0]  含义  (ax) = [(dx)*10000H+(ax)] / ((es)*16+0) 的商                        
                             (dx) = [(dx)*10000H+(ax)] / ((es)*16+0)) 的余数
  db 1 byte  define byte          8  位
  dw 2 byte  defile word          16 位
  dd 4 byte  define dword   32 位
  dup        duplicate  重复次数，配合 db dw dd 使用
  db 重复次数 dup(重复的字节型数据)
  db 3       dup(0)             重复3次 db ，数据为 0


9、 转移指令的原理
  可以修改 IP，或者同时修改 CS 和 IP 的指令统称为转移指令，转移指令就是可以控制 CPU 执行内存中某处代码的指令。
  8086CPU 的转移行为
    1) 只修改 IP 是，段内转移      jmp ax
       段内转移又分为 短转移和近转移
       短转移 IP 的修改范围 -128~127
       近转移 IP 的修改范围 -32768~32767
    2) 同时修改 CS 和 IP，段间转移 jmp 1000:0
  8086CPU 的指令
    1) 无条件转移指令(jmp)
    2) 条件转移指令
    3) 循环指令(loop)
    4) 过程
    5) 中断
(1) offset 标号   由汇编器处理，取得标号的偏移地址
(2) jmp 指令要给出两种信息：1) 转移的目的地址, 2) 转移的距离(段间转移、段内短转移、段内近转移)

(3) CPU 在执行 jmp 指令的时候并不需要转移的 目的地址，而是包含 转移的位移

  jmp short 标号 的功能：(IP)=(IP)+8位位移，段内短转移
  1) 8 位位移=标号处的地址 - jmp 指令后的第一个字节的地址
  2) short  指明此处的位移为 8 位位移
  3) 8 位位移的范围为 -128~127，用补码表示
  4) 8 位位移编译时计算出

  jmp near ptr 标号 的功能： (IP)=(IP)+16位位移，段内近转移
  1) 16 位位移的范围是 -32768~32767 
  
  jmp far ptr 标号 实现的是段间转移，又称远转移
  (CS)=标号所在段的段地址； (IP)=标号在段中的偏移地址
  far ptr 指明了指令用标号的段地址和偏移地址修改 CS 和 IP

  jmp 16 位寄存器 的功能： (IP)=(16 位寄存器)

  jmp word ptr 内存单元地址(段内转移)  (IP)=(内存地址)
  功能：从内存单元地址处存放一个字，是转移的 目的地址的 偏移地址

  jmp dword ptr 内存单元地址(段间转移)  (CS)=(内存单元高地址) (IP)=(内存单元低地址)
  功能：从内存单元地址处开始存放着两个字，高地址处的字是转移的 目的段地址(CS)，低地址处的字是转移的 目的偏移地址(IP)

(4) jcxz 指令为有条件转移指令，所有的条件转移指令都是短转移
  jcxz short 标号 ，如果 (CX)=0,转移到标号处执行，当(CX)=0 时，(IP)=(IP)+8 位位移

(5) loop 指令为循环指令，所有的循环指令都是短转移
  指令格式： loop 标号 (CX)=(CX)-1 ,如果 (CX)!=0，转移到标号处执行
  操作: 1)  (CX)=(CX)-1  ,  2) 如果(CX)!=0, (IP)=(IP)+8 位位移
  loop 标号  = (CX)--； if ((CX)!=0) jmp short 标号；

10、CALL 和 RET 指令 
  call 和 ret 指令都是转移指令，它们都修改 IP，或者同时修改 CS 和 IP

(1) ret 和 retf 
  ret 指令用栈中的数据，修改 IP 的内容，实现近转移
    1) (IP)=((SS)*16+(SP))
    2) (SP)=(SP)+2
   相当于 pop IP
  retf 指令用栈中的数据，修改 CS 和 IP 的内容，实现远转移
    1) (IP)=((SS)*16+(SP))
    2) (SP)=(SP)+2
    3) (CS)=((SS)*16+(SP))
    4) (SP)=(SP)+2
    相当于 pop IP ；pop CS

(2) call 指令 
  CPU 执行 call 指令时，1) 将当前的 IP 或 CS 和 IP 压入栈中，2) 转移
  call 标号 ，段内近转移
    1) (SP)=(SP)-2，((SS)*16+(SP))=(IP)
    2) (IP)=(IP)+16 位位移
    16 位位移 = 标号处的地址 - call 指令后的第一个字节的地址
    call 标号 = push IP ；jmp near ptr 标号

  call far ptr 标号，段间转移
    1) (SP)=(SP)-2，((SS)*16+(SP))=(CS)，(SP)=(SP)-2，((SS)*16+(SP))=(IP)
    2) (CS)=标号所在段的段地址，(IP)=标号在段中的偏移地址
    call far ptr 标号 = push CS；push IP；jmp far ptr 标号

  call 16 位 reg(寄存器)
    (SP)=(SP)-2
    ((SS)*16+(SP))=(IP)
    (IP)=(16 位 reg)
    相当于： push IP； jmp 16 位 reg

  call word ptr 内存单元地址
    相当于: push IP；jmp word ptr 内存单元地址((IP)=(内存单元地址))
  call dword ptr 内存单元地址
    相当于：push CS；push IP；jmp dword ptr 内存单元地址(高地址是 CS，低地址是 IP)
(3) call 和 ret 的配合使用，可以写一个具有一定功能的程序段，我们称其为子程序。call 指令执行子程序之前，call 指令后面的指令地址将存储到栈中，所以可以在子程序的后面使用 ret 指令，用栈中的数据设置 IP 的值，从而转到 call 指令后面的代码继续执行

(4) mul 指令，乘法指令
  1) 两个相乘的数：两个相乘的数，要么都是 8 位，要么都是 16 位。
    如果是 8 位，一个默认存放在 AL 中，另一个存放在 8 位 reg 或内存字节单元中。
    如果是 16 位，一个默认存放在 AX 中，另一个存放在 16 位 reg 或者内存字节单元中。
  2) 结果：如果是 8 位乘法，结果默认存放在 AX 中；如果是 16 位乘法，结果高位默认存放在 DX 中，低位在 AX 中。
  mul byte ptr ds:[0] 含义: (AX)=(AL)*((DS)*16+0)
  mul word ptr [bx+si+8] 含义: 
    (AX)=(AX)*((DS)*16+(BX)+(SI)+8) 结果的低 16 位
    (DX)=(AX)*((DS)*16+(BX)+(SI)+8) 结果的高 16 位

(5) 参数和结果的传递
  子程序一般都要根据提供的参数处理一定的事务，处理后，将结果(返回值)提供给调用者。
  1) 用寄存器存储参数和结果是最常使用的方法，调用者和子程序的读写操作相反：调用者将参数写入参数寄存器，从结果寄存器读取；子程序从参数寄存器中读取参数，将返回值写入结果寄存器
  2) 批量数据传递时，将批量数据放到内存中，然后将它们所在内存空间的首地址放到寄存器中，数据长度放到另外一个寄存器，传递给需要的子程序

(6) 寄存器冲突














































































