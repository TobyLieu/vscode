%include "boot.inc"
org 0x7e00
[bits 16]
mov ax, 0xb800
mov gs, ax
mov ah, 0x4f ;青色
mov ecx, bootloader_tag_end - bootloader_tag
xor ebx, ebx
mov esi, bootloader_tag
mov bx, 2*432
output_bootloader_tag:
    mov al, [esi]
    mov word[gs:bx], ax
    inc esi
    add ebx,2
    loop output_bootloader_tag

;空描述符
mov dword [GDT_START_ADDRESS+0x00],0x00
mov dword [GDT_START_ADDRESS+0x04],0x00  

;创建描述符，这是一个数据段，对应0~4GB的线性地址空间
mov dword [GDT_START_ADDRESS+0x08],0x0000ffff    ; 基地址为0，段界限为0xFFFFF
mov dword [GDT_START_ADDRESS+0x0c],0x00cf9200    ; 粒度为4KB，存储器段描述符 

;建立保护模式下的堆栈段描述符      
mov dword [GDT_START_ADDRESS+0x10],0x00000000    ; 基地址为0x00000000，界限0x0 
mov dword [GDT_START_ADDRESS+0x14],0x00409600    ; 粒度为1个字节

;建立保护模式下的显存描述符   
mov dword [GDT_START_ADDRESS+0x18],0x80007fff    ; 基地址为0x000B8000，界限0x07FFF 
mov dword [GDT_START_ADDRESS+0x1c],0x0040920b    ; 粒度为字节

;创建保护模式下平坦模式代码段描述符
mov dword [GDT_START_ADDRESS+0x20],0x0000ffff    ; 基地址为0，段界限为0xFFFFF
mov dword [GDT_START_ADDRESS+0x24],0x00cf9800    ; 粒度为4kb，代码段描述符 

;初始化描述符表寄存器GDTR
mov word [pgdt], 39      ;描述符表的界限   
lgdt [pgdt]
      
in al,0x92                         ;南桥芯片内的端口 
or al,0000_0010B
out 0x92,al                        ;打开A20

cli                                ;中断机制尚未工作
mov eax,cr0
or eax,1
mov cr0,eax                        ;设置PE位
      
;以下进入保护模式
jmp dword CODE_SELECTOR:protect_mode_begin

;16位的描述符选择子：32位偏移
;清流水线并串行化处理器
[bits 32]           
protect_mode_begin:                              

mov eax, DATA_SELECTOR                     ;加载数据段(0..4GB)选择子
mov ds, eax
mov es, eax
mov eax, STACK_SELECTOR
mov ss, eax
mov eax, VIDEO_SELECTOR
mov gs, eax

; ecx：用于loop计数
; ebx：确定字符显示位置
; esi：存储字符串位置
; ah：颜色
; al：字符
; ax：字符加颜色
mov ebx, 160 * 2
mov di, 0
mov dh, 0x03
mov esi, protect_mode_tag
mov ah, 0x3
mov dx, 0

;右下循环
L1: call move

    cmp di, 13
    je A1
    add di, 1
    jmp E11
A1: mov di, 0
E11:

    cmp dh, 0xff
    je B1
    add dh, 0x01
    jmp E12
B1: mov dh, 0x01
E12:

    cmp bx, 2*1920
    jge C1
    call judge_if_right1
    add bx, 2*81
    jmp L1
C1: sub bx, 2*79
    jmp L2
D1: add bx, 2*79
    jmp L4
;-----------------------------------------------------
;右上循环
L2: call move

    cmp di, 13
    je A2
    add di, 1
    jmp E21
A2: mov di, 0
E21:

    cmp dh, 0xff
    je B2
    add dh, 0x01
    jmp E22
B2: mov dh, 0x01
E22:

    cmp bx, 2*79
    jle C2
    call judge_if_right2
    sub bx, 2*79
    jmp L2
C2: add bx, 2*81
    jmp L1
D2: sub bx, 2*81
    jmp L3
;----------------------------------------------------
;左上循环
L3: call move

    cmp di, 13
    je A3
    add di, 1
    jmp E31
A3: mov di, 0
E31:

    cmp dh, 0xff
    je B3
    add dh, 0x01
    jmp E32
B3: mov dh, 0x01
E32:

    cmp bx, 2*79
    jle C3
    call judge_if_left1
    sub bx, 2*81
    jmp L3
C3: add bx, 2*79
    jmp L4
D3: sub bx, 2*79
    jmp L2
;---------------------------------------------------
;左下循环
L4: call move

    cmp di, 13
    je A4
    add di, 1
    jmp E41
A4: mov di, 0
E41:

    cmp dh, 0xff
    je B4
    add dh, 0x01
    jmp E42
B4: mov dh, 0x01
E42:

    cmp bx, 2*1920
    jge C4
    call judge_if_left2
    add bx, 2*79
    jmp L4
C4: sub bx, 2*81
    jmp L3
D4: add bx, 2*81
    jmp L1


jmp $ ; 死循环

;判断是否在最右边一列
judge_if_right1:
    push si
    mov si, 2*79
br1:cmp si, bx
    je Er3
    cmp si, bx
    jg Er1
    add si, 2*80
    jmp br1
Er1:pop si
    ret
Er3:pop si
    jmp D1

judge_if_right2:
    push si
    mov si, 2*79
br2:cmp si, bx
    je Er4
    cmp si, bx
    jg Er2
    add si, 2*80
    jmp br2
Er2:pop si
    ret
Er4:pop si
    jmp D2
;------------------------------------------------
;判断是否在最左边一列
judge_if_left1:
    push si
    mov si, 2*0
bl1:cmp si, bx
    je El3
    cmp si, bx
    jg El1
    add si, 2*80
    jmp bl1
El1:pop si
    ret
El3:pop si
    jmp D3

judge_if_left2:
    push si
    mov si, 2*0
bl2:cmp si, bx
    je El4
    cmp si, bx
    jg El2
    add si, 2*80
    jmp bl2
El2:pop si
    ret
El4:pop si
    jmp D4

move:
mov ah, dh
mov al, [esi+edi]
mov word[gs:ebx], ax
mov cx, 2*1999
sub cx, bx
mov bx, cx
mov word[gs:ebx], ax
mov cx, 2*1999
sub cx, bx
mov bx, cx
call delay
ret

delay:
push ecx
mov ecx, 5000000
delay_loop:
nop
loop delay_loop
pop ecx
ret

pgdt dw 0
     dd GDT_START_ADDRESS

bootloader_tag db 'Toby19335142'
bootloader_tag_end:

protect_mode_tag db '19335142liutuo'
protect_mode_tag_end: