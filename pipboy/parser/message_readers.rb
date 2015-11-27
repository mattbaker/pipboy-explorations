require 'json'
require_relative 'primitive_readers'
require_relative 'composite_readers'

module Pipboy
  module Parser
    module MessageReaders
      extend self

      def connection_accepted(stream, length)
        JSON.parse(stream.read(length))
      end

      def connect_refused(stream)
        "SERVER BUSY"
      end

      def data_update(stream, length)
        stop_position = stream.pos+length
        updates = []
        while stream.pos < stop_position
          type  = PrimitiveReaders.uint8(stream)
          id    = PrimitiveReaders.reference(stream)
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

      def keep_alive(stream)
        "KEEP ALIVE"
      end
    end
  end
end
