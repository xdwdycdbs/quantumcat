import socket,binascii,time,re


s=socket.socket()
s.connect(('127.0.0.1',8081))
regex=ur".*?REPORT.*?"
count=0
while 1:
 count+=1
 time.sleep(0.001)
 s.sendall(binascii.a2b_hex('02')+'/ONE1/'+binascii.a2b_hex('03')+binascii.a2b_hex('02')+'/ONE2/'+binascii.a2b_hex('03'))
 res=s.recv(1024)
 if res!='':
     match=re.search(regex,res)
     if match:
        print res
        s.sendall(binascii.a2b_hex('02')+'/RESPONSEFORREPORT/'+binascii.a2b_hex('03'))
 else:
     print 'No report NOW'
 time.sleep(0.01)   




