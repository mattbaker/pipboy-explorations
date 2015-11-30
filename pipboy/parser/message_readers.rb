require 'json'
require_relative 'primitive_readers'
require_relative 'composite_readers'
require_relative '../db/updates'

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
        database_updates = []

        while stream.pos < stop_position
          type   = PrimitiveReaders.uint8(stream)
          id     = PrimitiveReaders.reference(stream)
          update = case type
          when 0 then DB::Updates::Value.new(id, PrimitiveReaders.bool(stream))
          when 1 then DB::Updates::Value.new(id, PrimitiveReaders.sint8(stream))
          when 2 then DB::Updates::Value.new(id, PrimitiveReaders.uint8(stream))
          when 3 then DB::Updates::Value.new(id, PrimitiveReaders.sint32(stream))
          when 4 then DB::Updates::Value.new(id, PrimitiveReaders.uint32(stream))
          when 5 then DB::Updates::Value.new(id, PrimitiveReaders.float32(stream))
          when 6 then DB::Updates::Value.new(id, PrimitiveReaders.string(stream))
          when 7 then DB::Updates::Value.new(id, CompositeReaders.list(stream, PrimitiveReaders, :reference))
          when 8 then DB::Updates::Dictionary.new(id, *CompositeReaders.dict_update(stream))
          else
            raise "Unknown Data Type #{type}"
          end

          database_updates << update
        end

        database_updates
      end

      def keep_alive(stream)
        "KEEP ALIVE"
      end
    end
  end
end
