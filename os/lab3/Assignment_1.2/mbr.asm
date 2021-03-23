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
mov es, ax
mov bx, 0x7e00           ; bootloader的加载地址

call ReadSector

jmp 0x0000:0x7e00

jmp $ ; 死循环

; 利用BIOS中断读取硬盘
ReadSector:
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, 0x00
GoOnReading:
mov ah, 02h ; 从磁盘读入数据
mov al, 5 ; 要读扇区数
int 13h
jc GoOnReading
ret

times 510 - ($ - $$) db 0
db 0x55, 0xaa