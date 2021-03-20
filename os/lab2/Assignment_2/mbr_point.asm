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

;设置光标位置
mov ax, 0
mov ah, 02h
mov bh, 0
mov dh, 12
mov dl, 40
int 10h

;获取光标位置并进行检验
mov ax, 0
mov ah, 03h
mov dh, 0
int 10h
cmp dh, 12
jne exit
call DispStr
exit:
jmp $

DispStr:   
mov ax, BootMessage   
mov bp, ax ; es:bp = 串地址   
mov cx, 14 ; cx = 串长度   
mov ax, 01300h ; ah = 13, al = 00h   
mov bx, 000ch ; 页号为 0(bh = 0) 黑底红字(bl = 0Ch,高亮)   
mov dl, 0   
int 10h ; 10h 号中断   
ret

BootMessage db "get_pos right!"
times 510 - ($ - $$) db 0
db 0x55, 0xaa