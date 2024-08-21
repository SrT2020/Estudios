#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys 
import psutil
try: 
    if(len(sys.argv) == 2 and sys.argv[1].isdigit()):
        p = psutil.Process(int(sys.argv[1]))
        p.kill()
    else:
        print("pasame por parametro el numero PID")
except:
    print("error")