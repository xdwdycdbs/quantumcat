import urllib
import re

mainUrl="http://www.sina.com.cn"
regex=re.compile('<a .*? href="(http.*?)" .*?>(.*?)</a>')
nRegex=re.compile('<title>(.*?)</title>')
data=urllib.urlopen(mainUrl).read()
frontpageFile=open('./data/frontpage.dat','w')
nDataFile=open('./data/nUrlData.dat','w')

for subUrl,link in regex.findall(data):
    #print url,link
    frontpageFile.write(subUrl+' '+link+'\r\n')
    try:
        subData=urllib.urlopen(subUrl).read()
        for nTitle in nRegex.findall(subData):
            nDataFile.write(nTitle+'\r\n')
    except Exception:
        print "URL not access or some error else."
        continue
    
nDataFile.close()
frontpageFile.close()
