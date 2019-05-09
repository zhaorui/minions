#!/bin/bash

gcc -c -std=c99 -Wall -Wextra -pedantic -o main.o main.c
gcc -c -std=c99 -Wall -Wextra -pedantic -o notmain.o notmain.c
gcc -std=c99 -Wall -Wextra -pedantic -o main.out main.o notmain.o