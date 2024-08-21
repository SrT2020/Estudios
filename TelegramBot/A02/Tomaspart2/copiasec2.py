#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import os; import tarfile
file = open("/mnt/copiasec.txt", "r"); archhivo = "copiasec.tar"
try:
    for l in file.readlines():
        print(l); f = tarfile.open(archhivo,"w"); f.add(l[0:-1])
except:print("error")