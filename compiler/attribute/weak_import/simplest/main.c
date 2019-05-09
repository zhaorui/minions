#include <stdio.h>

int my_weak_var __attribute__((weak)) = 1;

int main(void) {
    printf("%d\n", my_weak_var);
}
