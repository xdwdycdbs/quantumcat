from SocketServer import TCPServer, ThreadingMixIn, StreamRequestHandler
import re,socket,threading,sys,time,multiprocessing
 
class Server(ThreadingMixIn, TCPServer):
   TCPServer.request_queue_size=50
 
class Handler(StreamRequestHandler):
   def handle(self):
     global count
     count+=1
     self.data=self.request.recv(2048).strip()
     regex=ur"<addresses>tel:.*</addresses>"
     match=re.search(regex,self.data)
     if match:
        msgQueue.put(match.group())
     self.wfile.write('HTTP/1.1 200 OK\r\nContent-Type: text/xml; charset=UTF-8\r\nConnection: close\r\n\r\n<body>')
  
def reportProcess():
   while 1:
     time.sleep(0.001)
     if msgQueue.qsize()>0:
        s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((host,int(port)))
        s.sendall(msgQueue.get())
        s.recv(1024)
        s.close()
 
def manageThreadDo():
   manageSocket=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   manageSocket.bind(('10.137.73.133',7000))
   manageSocket.listen(5)
   while 1:
      client,address=manageSocket.accept()     
      client.recv(1024)
      client.sendall(str(count))
 
def countTimer():
   if mode=="cluster":
      clusterCount=0
      #all node ip list
      nodeList=['10.137.73.131','10.137.73.133']
     
      for nodeIp in nodeList:
         cSocket=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
         try:
           cSocket.connect((nodeIp,7000))
           cSocket.sendall('getCount')
           nodeCount=cSocket.recv(1024)
           cSocket.close()
           clusterCount+=int(nodeCount)
         except Exception:
           break
      print "Messages received:",clusterCount,"qsize:",msgQueue.qsize()
   else:
      print "Messages received:",count
 
   countThd=threading.Timer(1,countTimer)
   countThd.start()
     
 
if __name__=='__main__':
   host=sys.argv[1]
   port=sys.argv[2]
   processNum=sys.argv[3]
   mode=sys.argv[4]
 
   #create msg queue and processes for sending reports
   msgQueue=multiprocessing.Queue(maxsize=10000)
   for i in range(int(processNum)):
      multiprocessing.Process(target=reportProcess).start()
 
   count=0
   if mode=="cluster":
      manageTh = threading.Thread(target=manageThreadDo)
      manageTh.start()
 
   #counter for both cluster mode and single mode
   countTimer()
 
   #listen on port 8081
   server = Server(('', 8081), Handler)
   server.serve_forever()
