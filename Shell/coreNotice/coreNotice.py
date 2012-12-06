import sys,smtplib,poplib

#set up addresses
smtpaddr="smtp.163.com"
fromaddr="yxt197@163.com"
toaddr="xyan@vmware.com"

#fill the info of mail
head=['From:yxt197@163.com',
      'To:xyan@vmware.com',
      'Subject:test python email']
msgbody=[sys.argv[1]]
msg='\r\n'.join(['\r\n'.join(head),
                 '\r\n'.join(msgbody)])

#send the mail
s=smtplib.SMTP(smtpaddr)
s.set_debuglevel(1)
s.login("yxt197","Youhuanmimala123")
s.sendmail(fromaddr,toaddr,msg)


