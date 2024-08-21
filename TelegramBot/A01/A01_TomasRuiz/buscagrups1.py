#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys         
def grup(x,ff):
    for y in ff:
        if x.split(":")[3] in y:
            print("El grup principal es: ",y.split(":")[0])

def user(f,ff):
    t=False
    for x in f:
            if sys.argv[1] == x.split(":")[0]:
                t=True
                print("Trobat\n",x)
                print("El seu GID es", x.split(":")[3])
                print("Trobat grup principal\n", x.split(":")[:3])
                grup(x,ff)
    if t==False:
        print("no s'ha trobat")

try: 
    
    if(len(sys.argv) == 2):
        f = open('/etc/passwd', "r").readlines(); ff = open('/etc/group', "r").readlines()
        print("Busquem informacio per l'usuari ", sys.argv[1])
        user(f,ff)
    else:
        print("dame un nombre de usuario porfavor")
except:
    print("error en ejecucion")
