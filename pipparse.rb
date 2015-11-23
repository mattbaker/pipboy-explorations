require_relative 'pipboy/message'

STDOUT.sync = true
STDIN.sync = true

until STDIN.eof? do
  message = Pipboy::Message.from_stream(STDIN)
  puts "Received #{message.type} with length #{message.length}"
end
