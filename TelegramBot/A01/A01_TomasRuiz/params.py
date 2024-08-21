#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys
suma=0
try: 
    if(len(sys.argv) > 1):
        for i in sys.argv[1:]:
            suma = suma + int(i)
        print("suma de numeros: ", suma)
    else:
        print ("Has d’indicar el nom de l’arxiu")
except:
    print("ocurrio un error")