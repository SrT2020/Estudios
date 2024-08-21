#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
from cgitb import text
import smtplib 
from email.mime.text import MIMEText
import sys

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

if (len(sys.argv) != 3):
    print("pasame el correo y el texto entre comillas por paramentro")
else:
    emisor  = ""
    clave = ""
    mandar_mail(sys.argv[1], sys.argv[2], emisor, clave)
