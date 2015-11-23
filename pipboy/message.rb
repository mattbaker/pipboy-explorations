module Pipboy
  class Message
    attr_reader :opcode, :body

    OPCODES = {
      0 => :KEEP_ALIVE,
      1 => :CONNECTION_ACCEPTED,
      2 => :CONNECTION_REFUSED,
      3 => :DATA_UPDATE,
      4 => :MAP_UPDATE,
      5 => :COMMAND,
      6 => :COMMAND_RESPONSE,
    }

    def initialize(opcode, body)
      @opcode = opcode
      @body = body
    end

    def type
      OPCODES.fetch(opcode, :UNKNOWN)
    end

    def hex_body
      body.unpack("H*")[0].upcase
    end

    def length
      body.length
    end

    def to_bytes
      [body.length, opcode].pack("IC") + body
    end

    def self.from_stream(stream)
      header = stream.read(5)
      length = header[0...4].unpack("I")[0]
      opcode = header[-1].unpack("C")[0]
      body = stream.read(length)
      Message.new(opcode, body)
    end

    def self.keep_alive
      self.new(0, "")
    end
  end
end
