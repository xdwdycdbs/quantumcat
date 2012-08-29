from SocketServer import TCPServer, ThreadingMixIn, StreamRequestHandler
import re,socket,threading,sys,time,multiprocessing,binascii,Queue
 
class Server(ThreadingMixIn, TCPServer):pass
 
class Handler(StreamRequestHandler):
   def handle(self):
     self.data=''
     global receiveReportRes
     threading.Thread(target=reportThread,args=(self.request,)).start()
     while 1:
        oneMsgData=''
        length=0
        if self.data=='':
           self.data=self.request.recv(2048).strip()
        if self.data!='':
           for c in self.data:
              if c==binascii.a2b_hex('02'):
                 continue
              if c==binascii.a2b_hex('03'):
                 self.data=self.data[length+2:]
                 #print self.data
                 break
              oneMsgData+=c
              length+=1
           print oneMsgData
           responseMsg=decode(oneMsgData)
           if responseMsg!='':
              self.wfile.write(responseMsg)              
        else:
           continue
        
     time.sleep(0.001)

def decode(req):
   global receiveReportRes
   dataArray=req.split('/')
   if dataArray[1]=='ONE1':
      msgQueue.put(req)
      res=binascii.a2b_hex('02')+'/SUBMITRESPONSE/'+binascii.a2b_hex('03')
      return res
   elif dataArray[1]=='RESPONSEFORREPORT':
      receiveReportRes=1
   return ''

def reportThread(theSocket):
   global receiveReportRes
   while 1:
      time.sleep(0.001)
      
      if msgQueue.qsize()>0 and receiveReportRes==1:
         print msgQueue.qsize()
         msgQueue.get()
         theSocket.sendall(binascii.a2b_hex('02')+'/REPORT/'+binascii.a2b_hex('03'))
         receiveReportRes=0
 
if __name__=='__main__':
   #create message queue
   msgQueue=Queue.Queue(maxsize=10000)

   #signal for report
   receiveReportRes=1
   
   #listen on port 8081
   server = Server(('', 8081), Handler)
   server.serve_forever()
