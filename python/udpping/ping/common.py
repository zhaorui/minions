#!/usr/bin/python
# -*- coding: utf-8 -*-


# In python 2 bytes is equal to str, things change in python 3, byts means binary.
def to_str(s):
    if bytes != str:
        if type(s) == bytes:
            return s.decode('utf-8')
    return s