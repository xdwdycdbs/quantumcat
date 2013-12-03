require 'socket'
require 'config'

include Socket::Constants

socket = Socket.new(AF_INET, SOCK_STREAM, 0)
sockaddr = Socket.sockaddr_in(65534, '10.29.66.21')
socket.bind(sockaddr)
socket.listen(5)
okCount=0

puts $account_list.count
#wait for the signals from agents
while 1 do
  client_socket, client_sockaddr = socket.accept
  message = client_socket.readline.chomp
  puts message
  puts okCount
  if nil != (message =~ /ok*/)
      okCount=okCount+1
      if okCount == $account_list.count
	 break
      end
  end
end
