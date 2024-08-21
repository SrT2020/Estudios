#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys; import psutil; import time
try:
    if(len(sys.argv) < 3 or len(sys.argv) > 7):
        print("pasame por parametros ram <numero>, cpu <numero> o disco <numero> o todos juntos")
    else:
        psutil.cpu_percent(0)
        cpu = float(psutil.cpu_percent(1))
        ram = float(psutil.virtual_memory().percent)
        disco = float(psutil.disk_usage('/').percent)
        for x in range(1, len(sys.argv)):
            if sys.argv[x] == "cpu":
                if float(sys.argv[x+1]) < cpu: 
                    a = print(f"""Consumo cpu actual {cpu}%\nConsumo de cpu superior a {sys.argv[x+1]}%""")
                else:
                    print(f"Consumo cpu actual {cpu}%, no superas el {sys.argv[x+1]}%")
            if sys.argv[x] == "ram":
                if float(sys.argv[x+1]) < ram: 
                    print(f"""Consumo ram actual {ram}%\nConsumo de ram superior a {sys.argv[x+1]}%""")
                else:
                    print(f"Consumo ram actual {ram}%, no superas el {sys.argv[x+1]}%")
            if sys.argv[x] == "espai":
                if float(sys.argv[x+1]) < disco: 
                   print(f"""Consumo espacio actual {disco}%\nConsumo de espacio superior a {sys.argv[x+1]}%""")
                else:
                    print(f"Consumo espacio actual {disco}%, no superas el {sys.argv[x+1]}%")
except:
    print("mira el script")