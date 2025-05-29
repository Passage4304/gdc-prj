#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    __pid_t pid = fork();

    if (pid == 0) {
        // Дочерний процесс
        sleep(5);  // Ждёт, пока родитель умрёт
        printf("Child (PID: %d), new parent PID: %d\n", getpid(), getppid());
        sleep(10); // Подожди, чтобы увидеть в ps
    } else {
        // Родительский процесс
        sleep(3);
        printf("Parent (PID: %d) exiting...\n", getpid());
        exit(0);  // Завершается и оставляет сироту
    }

    return 0;
}
