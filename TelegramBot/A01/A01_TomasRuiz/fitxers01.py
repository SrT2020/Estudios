#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys
try: 
    i = 1
    f = open("fitxer01.txt",'r')
    for line in f.readlines():
        if i % 2 != 0:
            print(line[:-1]) 
        i += 1
except:
    print("error de ejecucion")