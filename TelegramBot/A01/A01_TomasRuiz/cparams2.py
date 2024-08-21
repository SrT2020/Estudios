#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys  
try: 
    if(len(sys.argv[1:]) > 1 and len(sys.argv[1:]) < 3):
        if sys.argv[1].isdigit():
            print ("el primer parametre es un numero")
        print("Be, has posat: ",len(sys.argv[1:])," parametres")
    else:
        print ("ERROR, has de posar dos parametres, has posat: ", len(sys.argv[1:])," parametres")
except:
    print("error de ejecucion")