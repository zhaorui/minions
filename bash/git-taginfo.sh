#!/bin/bash
while read i; do echo -n "$i "; git rev-parse $i | tr '\n' ' '; git rev-list --count  $i; done < <(git tag -l)