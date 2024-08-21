#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
import sys 
import psutil
def getListOfProcessSortedByCpu():
    listOfProcObjects = []
    # Iterate over the list
    for proc in psutil.process_iter():
        try:
           # Fetch process details as dict
           pinfo = proc.as_dict(attrs=['pid', 'name','cpu_percent'])
           # Append dict to list
           listOfProcObjects.append(pinfo)
           
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass 
    # Sort list of dict by key vms i.e. memory usage
    listOfProcObjects = sorted(listOfProcObjects, key=lambda procObj: procObj['cpu_percent'], reverse=True)
    return listOfProcObjects

try: 
    if(len(sys.argv) == 2):
        if sys.argv[1] == "cpu": print('The CPU usage is: ', psutil.cpu_percent(1), "%")
        elif sys.argv[1] == "ram": print('RAM memory used:', psutil.virtual_memory()[2], "%")
        elif sys.argv[1] == "espai": 
            hdd = psutil.disk_usage('/')
            print ("Total:",hdd.total //(1024**3)," GiB")
            print ("Used:", hdd.used //(1024**3)," GiB")
            print ("Free:",hdd.free //(1024**3)," GiB")
        else: print("los parametros son cpu, ram o espai")

    elif(sys.argv[1] == "cpu" and sys.argv[2].isdigit()):
        lista = getListOfProcessSortedByCpu()
        for i in lista[:int(sys.argv[2])]:
            print(i['pid'], i['name'], i['cpu_percent'])
            
    else:
        print("los parametros son cpu, ram o espai")
except:
    print("error")