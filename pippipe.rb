require 'socket'

STDOUT.sync = true

socket = TCPSocket.new('192.168.0.101', 27000)

while line = socket.recv(8)
  if line == "\x00\x00\x00\x00\x00"
    socket.send("\x00\x00\x00\x00\x00", 0)
  end
  n = STDOUT.write(line)
end
socket.close
