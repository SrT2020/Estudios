#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys; import os; import time
try:
    files = []
    if(len(sys.argv) == 2 and int(sys.argv[1]) >= 60 and int(sys.argv[1]) <= 300):
        while True: 
            for i in os.listdir(os.getcwd()):
                if i not in files:
                    files.append(i) 
                    print(i + "Nuevo archivo")
                else:
                    print(i)
            time.sleep(int(sys.argv[1]))
    else: print("pasame los segundos, entre 60 y 300")
except: print("error")