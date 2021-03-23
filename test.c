#include <stdio.h>
#include <unistd.h>
//在fork时把父进程的代码做了一个拷贝，因此会输出两行：父进程的pid和子进程的pid
int main(){
    int pid;
    pid = fork();
    printf("%d \n",pid);
    return 0;
}