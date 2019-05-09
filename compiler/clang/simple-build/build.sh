#!/bin/bash
clang -E main.m -o complete_main.m
clang main.m -lobjc -framework Foundation -o main