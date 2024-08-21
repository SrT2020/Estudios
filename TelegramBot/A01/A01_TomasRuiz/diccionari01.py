#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys
list = []
cont= 0
#dicc01 = {'/bin/bash': cont, '/bin/sh': cont, '/bin/sync' : cont, '/bin/false': cont}
dicc01 = {}
try: 
    f = open('/etc/passwd', "r").readlines()
    for x in f:
        last=x.split(":")[-1].rstrip("\n")
        if last not in dicc01:
            dicc01[last]=cont
        if last in dicc01:
            dicc01[last]=dicc01[last] + 1
        #if "/usr/sbin/nologin" in last or "/bin/false" in last:
        #    list.append(x.split(":")[0])

    #print(list)
    print(dicc01)
except:
     print("error en ejecucion")
