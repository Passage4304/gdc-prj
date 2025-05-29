#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    __pid_t pid = fork();

    if (pid == 0) {
        // Дочерний процесс сразу завершился
        printf("Child process (PID: %d) exiting...\n", getpid());
        exit(0);
    } else {
        // Родитель не вызывает wait(), а спит
        printf("Parent process (PID: %d), child PID: %d\n", getpid(), pid);
        sleep(30);  // Достаточно времени, чтобы увидеть зомби в ps/top
    }

    return 0;
}
