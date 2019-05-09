#include <stdio.h>
#include <stdlib.h>

extern int f (int) __attribute__((weak_import));

int main() {
    if(f == NULL)
        printf("what, no f?\n");
    else
        printf("f(8) is %d\n", f(8));
    exit(0);
}