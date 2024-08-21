#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys; import subprocess
try:
    if len(sys.argv) != 2:print("pasame la interficie")
    else:
        print("Tu mac es: ", subprocess.getoutput(f"ip a s {sys.argv[1]} | grep link/ether | tr -s \" \" | cut -f3 -d\" \" "))
        print("Tu IP es: ", subprocess.getoutput(f"ip a s {sys.argv[1]} | grep 'inet ' | tr -s \" \" | cut -f3 -d\" \" "))
except:print("error")