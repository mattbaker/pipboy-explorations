require_relative 'primitive_readers'

module Pipboy
  module Parser
    module CompositeReaders
      extend self

      def header(stream)
        [PrimitiveReaders.uint32(stream), PrimitiveReaders.uint8(stream)]
      end

      def list(stream, mod, type)
        arr = []
        count = PrimitiveReaders.uint16(stream)
        count.times do
          arr << mod.send(type, stream)
        end
        arr
      end

      def dict_entry(stream)
        value = PrimitiveReaders.reference(stream)
        key = PrimitiveReaders.string(stream)
        {key => value}
      end

      def dict_update(stream)
        updates = list(stream, CompositeReaders, :dict_entry)
        removals = list(stream, PrimitiveReaders, :reference)
        {updates: updates, removals: removals}
      end
    end
  end
end
