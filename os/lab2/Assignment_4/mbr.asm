org 0x7c00
[bits 16]
xor ax, ax ; eax = 0
; 初始化段寄存器, 段地址全部设为0
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax

; 初始化栈指针
mov sp, 0x7c00
mov ax, 0xb800
mov gs, ax

;输出姓名学号
mov ah, 0x4f ;漫威配色
mov al, 'T'
mov [gs:2 * 432], ax

mov al, 'o'
mov [gs:2 * 433], ax

mov al, 'b'
mov [gs:2 * 434], ax

mov al, 'y'
mov [gs:2 * 435], ax

mov al, '1'
mov [gs:2 * 436], ax

mov al, '9'
mov [gs:2 * 437], ax

mov al, '3'
mov [gs:2 * 438], ax

mov al, '3'
mov [gs:2 * 439], ax

mov al, '5'
mov [gs:2 * 440], ax

mov al, '1'
mov [gs:2 * 441], ax

mov al, '4'
mov [gs:2 * 442], ax

mov al, '2'
mov [gs:2 * 443], ax

mov bx, 160*2
mov di, 0
mov dh, 0x01
;-------------------------------------------
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

move:
mov ah, dh
mov al, [msg+di]
mov [gs:bx], ax
mov cx, 2*1999
sub cx, bx
mov bx, cx
mov [gs:bx], ax
mov cx, 2*1999
sub cx, bx
mov bx, cx
call delay
ret
;------------------------------------------------
;延迟函数
delay:
mov al,dh
mov ah,86h
mov cx,0x05
mov dx,0x8480     
int 15h
mov dh,al
ret
;-------------------------------------------
;判断是否在最右边一列
judge_if_right1:
    mov si, 2*79
br1:cmp si, bx
    je D1
    cmp si, bx
    jg Er1
    add si, 2*80
    jmp br1
Er1:ret

judge_if_right2:
    mov si, 2*79
br2:cmp si, bx
    je D2
    cmp si, bx
    jg Er2
    add si, 2*80
    jmp br2
Er2:ret
;------------------------------------------------
;判断是否在最左边一列
judge_if_left1:
    mov si, 2*0
bl1:cmp si, bx
    je D3
    cmp si, bx
    jg El1
    add si, 2*80
    jmp bl1
El1:ret

judge_if_left2:
    mov si, 2*0
bl2:cmp si, bx
    je D4
    cmp si, bx
    jg El2
    add si, 2*80
    jmp bl2
El2:ret

jmp $ ; 死循环

msg db "19335142liutuo"

times 510 - ($ - $$) db 0
db 0x55, 0xaa