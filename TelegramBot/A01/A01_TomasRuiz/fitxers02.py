#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys
try: 
    if(len(sys.argv) == 3):
        f = open(sys.argv[1], "r")
        d = f.read()
        n = d.count(sys.argv[2])
        print("La cadena",sys.argv[2],"es troba un total de ",n," vegades")
    else:
        print("dame el nombre del archivo y la letra a buscar")
except:
    print("error de ejecucion")