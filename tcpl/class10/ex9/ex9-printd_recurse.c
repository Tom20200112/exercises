#include <stdio.h>

/* printd:  print n in decimal */
void printd(int n) {
    if (n < 0) {
        putchar('-');
        n = -n;
    }

    if (n / 10) printd(n / 10);

    putchar(n % 10 + '0');
}

int main(void) {
    int a;
    printf("please input an integer: ");

    scanf("%d", &a);
    printd(a);
    printf("\n");

    return 0;
}