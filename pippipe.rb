require 'socket'

STDOUT.sync = true
ip = ARGV[0]
socket = TCPSocket.new(ip, 27000)
keep_alive = "\x00\x00\x00\x00\x00"

while line = socket.recv(8)
  if line == keep_alive
    socket.send(keep_alive, 0)
  end
  n = STDOUT.write(line)
end

socket.close
