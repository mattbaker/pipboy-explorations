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
      when 3 then read_data_update(stream, length)
      else
        "NOT IMPLEMENTED"
      end

      {message_type: OPCODE_NAMES[opcode], message_body: body}
    end

    def read_data_update(stream, length)
      stop_position = stream.pos+length
      updates = []
      while stream.pos < stop_position
        type = PrimitiveReaders.uint8(stream)
        id = PrimitiveReaders.reference(stream)
        value = case type
                when 0 then PrimitiveReaders.bool(stream)
                when 1 then PrimitiveReaders.sint8(stream)
                when 2 then PrimitiveReaders.uint8(stream)
                when 3 then PrimitiveReaders.sint32(stream)
                when 4 then PrimitiveReaders.uint32(stream)
                when 5 then PrimitiveReaders.float32(stream)
                when 6 then PrimitiveReaders.string(stream)
                when 7 then CompositeReaders.list(stream, PrimitiveReaders, :reference)
                when 8 then CompositeReaders.dict_update(stream)
                else
                  raise "Unknown Data Type #{type}"
                end
        updates << {set: id, value: value}
      end
      updates
    end
  end
end
