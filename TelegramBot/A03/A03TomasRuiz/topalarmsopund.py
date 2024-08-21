#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
email = "toruse@fp.insjoaquimmir.cat"
clave = "litorus2122"
from playsound import playsound
import imaplib
import email
import time
import os

def get_body(tmsg):    
    body = ""
    if tmsg.is_multipart():        
        for part in tmsg.walk():
            ctype = part.get_content_type()
            cdispo = str(part.get('Content-Disposition'))          
            if ctype == 'text/plain' and 'attachment' not in cdispo:
                body = str(part.get_payload(decode=True))  
                body=body.replace("\\r\\n","\n")                
                break
    else:
        body = str(tmsg.get_payload(decode=True))
    return body

def get_emailinfo(id, data, bshowbody=False):
    for contenido in data:

        if isinstance(contenido, tuple):                    
                   
            msg = email.message_from_string(contenido[1].decode())

            print ("%d - *** %s ***" % (id, msg['subject'].upper()))
            print ("enviado por %s" % msg['from'])
            print ("para %s" % msg['to'])
            if(bshowbody):
                print ("---                                                   ---")
                print(get_body(msg))
                print ("--------------------------------------------------------")
            return True
    return False

def get_emails(get_emailss, gmailsmtpsvr, gmailusr, gmailpwd, bshowbody):
    try:
        mail = imaplib.IMAP4_SSL(gmailsmtpsvr)
        mail.login(gmailusr, gmailpwd)
        mail.select("inbox")      
        result, data = mail.search(None, '(SUBJECT "Correo Estado")')
        strids = data[0] 
        lstids = strids.split()
        firstid = int(lstids[0])
        lastid = int(lstids[-1])

        print("primer id: %d\nultimo id: %d\n..." % (firstid, lastid))

        for id in range(lastid, firstid-1, -1):            
            typ, data = mail.fetch(str(id), '(RFC822)' ) 
            if (get_emailinfo(id, data, bshowbody)):
                get_emailss+=1
        print("emails listados %d" % get_emailss)
    except Exception as e:
        print("Error: %s" % (e))
        return ""
    except:
        print("Error desconocido")
        return ""

while True:
    get_emails(get_emailss,"smtp.gmail.com", "toruse@fp.insjoaquimmir.cat", "litorus2122",False)
    playsound('sonido.mp3')
    time.sleep(5); os.system("clear")