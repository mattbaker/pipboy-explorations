require 'socket'
require_relative 'pipboy/message'

STDOUT.sync = true

socket = TCPSocket.new('192.168.0.101', 27000)

while line = socket.recv(8)
  if line == Pipboy::Message.keep_alive.to_bytes
    socket.send(Pipboy::Message.keep_alive.to_bytes, 0)
  end
  n = STDOUT.write(line)
end
socket.close
