require_relative 'pipboy/message'

STDOUT.sync = true
STDIN.sync = true
MAX_PAYLOAD_LENGTH = 64

i = 0
until STDIN.eof? do
  message = Pipboy::Message.from_stream(STDIN)
  puts "#{i.to_s.rjust(5, "0")}: #{message.type} with length #{message.length}"
  unless message.body.empty?
    puts "       #{message.hex_body[0...MAX_PAYLOAD_LENGTH]}#{"..." if message.hex_body.length > MAX_PAYLOAD_LENGTH}"
  end
  i+=1
end
