#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys 
import os
import time
import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.connect(('8.8.8.8', 80))
ip = sock.getsockname()[0]
ip2 = list(ip.split(".")[:3])
ip2.append("*")
ip3 = ip2[0] + "." + ip2[1] + "." + ip2[2] + "." + ip2[3]
ips = []
try: 
    if(len(sys.argv) == 2 and int(sys.argv[1]) >= 3 or int(sys.argv[1]) <= 300):
        while True:
            for x in os.popen(f"nmap -sn -oG - {ip3} | grep Up | cut -d ' ' -f 2"):
                # print(ips)
                if x[:-1] not in ips:
                    ips.append(x[:-1])
                    print(x[:-1], "se ha conectado")
                else:
                    ips.append(x[:-1])
                    print(x[:-1])
            print("------")
            time.sleep(int(sys.argv[1])*60)
    else:
        print("pasame los segundos, entre 60 y 300")
except:
    print("error")