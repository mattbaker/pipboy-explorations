require_relative 'primitive_readers'
require_relative 'composite_readers'
require_relative 'message_readers'

module Pipboy
  module Parser
    extend self

    OPCODE_NAMES = {
      0 => :KEEP_ALIVE,
      1 => :CONNECTION_ACCEPTED,
      2 => :CONNECTION_REFUSED,
      3 => :DATA_UPDATE,
      4 => :MAP_UPDATE,
      5 => :COMMAND,
      6 => :COMMAND_RESPONSE,
    }

    def parse_message(stream)
      length, opcode = CompositeReaders.header(stream)
      body = case opcode
      when 0 then MessageReaders.keep_alive(stream)
      when 1 then MessageReaders.connection_accepted(stream, length)
      when 2 then MessageReaders.connect_refused(stream)
      when 3 then MessageReaders.data_update(stream, length)
      else
        "NOT IMPLEMENTED"
      end

      {message_type: OPCODE_NAMES[opcode], message_body: body}
    end
  end
end
