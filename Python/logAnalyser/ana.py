import os
import sys
import re
from multiprocessing import Process,Queue
 
def processFiles(files,queue,keyword):
   mydict={}
   regex=ur"\d{6}"
   for file in files:
     f=open(file,'r')
     lines=f.readlines()
     for line in lines:
       time=line[11:13]+line[14:16]+line[17:19]
       if re.search(regex,time):
         if time in mydict.keys():
           if keyword in line:
             mydict[time]+=1
         else:
           mydict[time]=1
     f.close()
   queue.put(mydict)
 
def merge(adict,bdict):
   for key in bdict.keys():
     if key in adict.keys():
        adict[key]+=bdict[key]
     else:
        adict[key]=bdict[key]
   return adict
 
def writeToFile(myDict):
   keys=myDict.keys()
   keys.sort()
   fwrite=open('result.csv','w')
   for key in keys:
      fwrite.write(key+','+str(myDict[key])+'\n')
   fwrite.close()
 
if __name__=='__main__':
   path=sys.argv[1]
   keyword=sys.argv[2]
 
   allfileslist=os.listdir(path)
   queue=Queue()
 
   p1=Process(name='p1',target=processFiles,args=(allfileslist[0:100],queue,keyword))
   p2=Process(name='p2',target=processFiles,args=(allfileslist[100:213],queue,keyword))
   p1.start()
   p2.start()
   p1.join()
   p2.join()
 
   writeToFile(merge(queue.get(),queue.get()))
