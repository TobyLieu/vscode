org 0x7c00 ; 告诉编译器程序加载到 7c00处   
mov ax, cs   
mov ds, ax   
mov es, ax                       
call DispStr ; 调用显示字符串例程   
jmp $ ; 无限循环   

DispStr:   
mov ax, BootMessage   
mov bp, ax ; es:bp = 串地址   
mov cx, 8 ; cx = 串长度   
mov ax, 01301h ; ah = 13, al = 01h   
mov bx, 000ch ; 页号为 0(bh = 0) 黑底红字(bl = 0Ch,高亮)   
mov dl, 0   
int 10h ; 10h 号中断   
ret

BootMessage db "19335142"
times 510 - ($ - $$) db 0
db 0x55, 0xaa