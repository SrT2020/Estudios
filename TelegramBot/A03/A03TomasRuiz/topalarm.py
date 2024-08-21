#!/usr/bin/python
# -*- coding: utf-8 -*-
#TOMASRUIZ2122
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

def get_emails(gmailsmtpsvr, gmailusr, gmailpwd, bshowbody):
    try:
        mail = imaplib.IMAP4_SSL(gmailsmtpsvr)
        mail.login(gmailusr, gmailpwd)
        mail.select("inbox")      
        result, data = mail.search(None, '(SUBJECT "Correo Estado")')
        strids = data[0] 
        lstids = strids.split()
        firstid = int(lstids[0])
        lastid = int(lstids[-1])
        countid = 0

        print("primer id: %d\nultimo id: %d\n..." % (firstid, lastid))

        for id in range(lastid, firstid-1, -1):            
            typ, data = mail.fetch(str(id), '(RFC822)' ) 
            if (get_emailinfo(id, data, bshowbody)):
                countid+=1
        print("emails listados %d" % countid)
    except Exception as e:
        print("Error: %s" % (e))
        return ""
    except:
        print("Error desconocido")
        return ""
while True:
    get_emails("smtp.gmail.com", "", "",False)
    time.sleep(5); os.system("clear")
