module Pipboy
  module DB
    module Updates
      class Value
        attr_reader :ref, :value

        def initialize(ref, value)
          @ref = ref
          @value = value
        end

        def to_json(*a)
          { ref: ref,
            value: value,
            type: "value" }.to_json(*a)
        end

        def self.from_hash(hash)
          new(hash["ref"], hash["value"])
        end

        def ==(other)
          other.is_a?(self.class) &&
          other.ref == ref &&
          other.value == value
        end
      end

      class Dictionary
        attr_reader :ref, :entries, :removals

        def initialize(ref, entries, removals)
          @ref = ref
          @entries = entries
          @removals = removals
        end

        def ==(other)
          other.is_a?(self.class) &&
          other.ref == ref &&
          other.entries == entries &&
          other.removals == removals
        end

        def to_json(*a)
          { ref: ref,
            entries: entries,
            removals: removals,
            type: "dictionary" }.to_json(*a)
        end

        def self.from_hash(hash)
          new(hash["ref"], hash["entries"], hash["removals"])
        end
      end
    end
  end
end
