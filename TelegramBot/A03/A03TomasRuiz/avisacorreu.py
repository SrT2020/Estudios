#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
from cgitb import text
import smtplib 
from email.mime.text import MIMEText
import sys; import psutil;
def mandar_mail(destino, texto, emisor, clave):
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.ehlo()
        server.starttls()
        server.ehlo()
        
        server.login(emisor, clave)

        asunto = "Correo Python"
        body = texto

        msg = MIMEText(body.encode('UTF-8'), 'plain', 'UTF-8')
        msg["From"] = emisor
        msg["To"] = destino
        msg["Subject"] = asunto

        server.sendmail(
            emisor,
            destino,
            msg.as_string()
        )

        server.quit()

        print("Correo enviado")

    except Exception as ex:
        print(ex) 
try:
    emisor  = ""
    clave = ""
    if(len(sys.argv) < 3 or len(sys.argv) > 8):
        print("pasame por parametros correo@correo ram <numero>, cpu <numero> o disco <numero> o todos juntos")
    else:
        psutil.cpu_percent(0)
        cpu = psutil.cpu_percent(1)
        ram = psutil.virtual_memory().percent
        disco = psutil.disk_usage('/').percent
        texto = ""
        for x in range(2, len(sys.argv)):
            if sys.argv[x] == "cpu":
                if float(sys.argv[x+1]) < cpu: 
                    print(f"""Consumo cpu actual {cpu}%\nConsumo de cpu superior a {sys.argv[x+1]}%""")
                    texto += f"Consumo cpu actual {cpu}%\nConsumo de cpu superior a {sys.argv[x+1]}%\n"
                else:
                    print(f"Consumo cpu actual {cpu}%, no superas el {sys.argv[x+1]}%")
            if sys.argv[x] == "ram":
                if float(sys.argv[x+1]) < ram: 
                    print(f"""Consumo ram actual {ram}%\nConsumo de ram superior a {sys.argv[x+1]}%""")
                    texto += f"Consumo ram actual {ram}%\nConsumo de ram superior a {sys.argv[x+1]}%\n"
                else:
                    print(f"Consumo cpu actual {ram}%, no superas el {sys.argv[x+1]}%")
            if sys.argv[x] == "espai":
                if float(sys.argv[x+1]) < disco: 
                    print(f"""Consumo espacio actual {disco}%\nConsumo de espacio superior a {sys.argv[x+1]}%""")
                    texto += f"Consumo espacio actual {disco}%\nConsumo de espacio superior a {sys.argv[x+1]}%\n"
                else:
                    print(f"Consumo cpu actual {disco}%, no superas el {sys.argv[x+1]}%")
        if len(texto) > 1:
            mandar_mail(sys.argv[1], texto, emisor, clave)
except:
    print("mira el codigo")
