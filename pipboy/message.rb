module Pipboy
  class Message
    attr_reader :opcode, :body

    OPCODES = {
      "\x0" => :KEEP_ALIVE,
      "\x1" => :CONNECTION_ACCEPTED,
      "\x2" => :CONNECTION_REFUSED,
      "\x3" => :DATA_UPDATE,
      "\x4" => :MAP_UPDATE,
      "\x5" => :COMMAND,
      "\x6" => :COMMAND_RESPONSE,
    }

    def initialize(opcode, body)
      @opcode = opcode
      @body = body
    end

    def type
      OPCODES.fetch(opcode, :UNKNOWN)
    end

    def length
      body.length
    end

    def self.from_stream(stream)
      header = stream.read(5)
      length = header[0...4].unpack("I")[0]
      opcode = header[-1]
      body = stream.read(length)
      Message.new(opcode, body)
    end
  end
end
