#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
#!!!!contenido de la version de v04 para minimaz entrega de ficheros, 
# misma finalidad pero resultado ampliado!!!!!!!!!!!
import sys
list = []
try: 
    if(len(sys.argv) == 3):
        f = open(sys.argv[1], "r")
        d = f.read()
        n = d.count(sys.argv[2])
        index = 0
        while index < len(d):
            index = d.find(sys.argv[2], index)
            if index == -1:
                break
            print(sys.argv[2],' esta en la posicio', index)
            list.append(index)
            index += 1
        print("La cadena",sys.argv[2],"es troba un total de ",n," vegades")
        print(list)
    else:
        print("dame el nombre del archivo o su ubicacion")
except:
    print("error en ejecucion")