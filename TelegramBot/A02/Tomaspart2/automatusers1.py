#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
# try:
import os
import pwd
import subprocess
import sys
if os.path.exists("usuaris.txt"):
    print ("usuaris.txt existe")
    file = open("usuaris.txt", "r")
    for l in file.readlines():
        u,Gi,Gs,D= l.split(',')
        check = pwd.getpwnam(u)
        if check:
            print(f" the user {u} exists") 
        else:
            print (f"No, the user {u} does not exist")
            if not os.path.exists("usuaris.txt"):
                os.makedirs(D)
            check = pwd.getpwnam(u)
            subprocess.run(['useradd', '-g', '-G', '-d', u, Gi, Gs, D])   


else:print ("usuaris.txt no esta")


# except:print("error")