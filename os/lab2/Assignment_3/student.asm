; If you meet compile error, try 'sudo apt install gcc-multilib g++-multilib' first
[bits 32]

%include "head.include"

your_if:
        mov eax,[a1]
        cmp eax,12
        jl L1
        cmp eax,24
        jl L2
        shl eax,4
        jmp exit
L1:     imul eax,eax,2
        add eax,1
        jmp exit
L2:     mov ebx,24
        sub ebx,eax
        imul ebx,eax
        mov eax,ebx
exit:   mov [if_flag],eax


your_while:
        mov ebx,[a2]
        mov esi, dword[while_flag]
beginwhile:
        cmp ebx,12
        jl endwhile
        call my_random
        mov [esi+ebx-12],al
        dec ebx
        mov [a2],ebx
        jmp beginwhile
endwhile:

%include "end.include"

your_function:
        mov ecx,0
        mov edx,dword[your_string]
begin:  mov eax, 0
        mov al, [edx+ecx]
        cmp eax, 0
        je end
        pushad
        push eax
        call print_a_char
        pop eax
        popad
        inc ecx
        jmp begin
end:    ret
