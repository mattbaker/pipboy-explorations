require 'socket'
require_relative 'pipboy/message'

STDOUT.sync = true
ip = ARGV[0]
socket = TCPSocket.new(ip, 27000)
keep_alive_msg = Pipboy::Message.keep_alive.to_bytes

while line = socket.recv(8)
  if line == keep_alive_msg
    socket.send(keep_alive_msg, 0)
  end
  n = STDOUT.write(line)
end

socket.close
