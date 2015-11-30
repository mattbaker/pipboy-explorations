require 'pp'
require 'json'
require_relative 'pipboy/parser/parser'
require_relative 'pipboy/db/database'

STDOUT.sync = true
STDIN.sync = true

until STDIN.eof? do
  STDOUT.puts(Pipboy::Parser.parse_message(STDIN).to_json)
end
