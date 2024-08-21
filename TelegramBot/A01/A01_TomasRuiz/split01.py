#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys
list = []
try: 
    f = open('/etc/passwd', "r").readlines()
    for x in f:
        list.append(x.split(":")[0])
    print(list)
except:
    print("error en ejecucion")