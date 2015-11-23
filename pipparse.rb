require_relative 'pipboy/message'

STDOUT.sync = true
STDIN.sync = true

i = 0
until STDIN.eof? do
  message = Pipboy::Message.from_stream(STDIN)
  puts "#{i.to_s.rjust(5, "0")}: #{message.type} with length #{message.length}"
  i+=1
end
