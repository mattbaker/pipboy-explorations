module Pipboy
  module Parser
    module PrimitiveReaders
      extend self
      def bool(stream)
        stream.read(1).unpack("C")[0] == 1
      end

      def sint8(stream)
        stream.read(1).unpack("c")[0]
      end

      def uint8(stream)
        stream.read(1).unpack("C")[0]
      end

      def uint16(stream)
        stream.read(2).unpack("S")[0]
      end

      def sint32(stream)
        stream.read(4).unpack("l")[0]
      end

      def uint32(stream)
        stream.read(4).unpack("L")[0]
      end

      def float32(stream)
        stream.read(4).unpack("F")[0]
      end

      def string(stream)
        string = ""
        while (char = stream.read(1)) && char != "\x00"
          string << char
        end
        string
      end

      def reference(stream)
        uint32(stream)
      end
    end
  end
end
