require 'socket'

begin
    client = TCPSocket.open('10.29.66.21', '65534')
    client.send("ok #{ARGV[0]}", 0)
    client.close
rescue  => err
	puts err
end

