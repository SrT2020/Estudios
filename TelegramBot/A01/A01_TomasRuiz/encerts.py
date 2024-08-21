#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import random
valor=random.randint(1,100)
encert=True
print(valor)
try: 
    while (encert):
        a=int(input("Dime un numero: "))
        if a==valor:
            encert=False
    print("enhorabuena el numero era:", valor)
except:
    print("ocurrio un error")