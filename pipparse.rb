require 'pp'
require 'json'
require_relative 'pipboy/parser/parser'

STDOUT.sync = true
STDIN.sync = true
MAX_PAYLOAD_LENGTH = 64

until STDIN.eof? do
  message = Pipboy::Parser.parse_message(STDIN)
  STDOUT.puts(message.to_json)
end
