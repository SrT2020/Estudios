#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import os
file = open("mnt/copiasec.txt", "r")
os.system("mkdir /tmp/copiasec/")
try:
    for x in file.readlines():
        os.system("cp -r " + x[:-1] + f" /tmp/copiasec/{x.split('/')[-1]}")
        print(f"copia feta de {x}")
    print("-------/tmp")
    os.system("ls /tmp | grep copiasec | ls /tmp/copiasec")
except:
    print("error")