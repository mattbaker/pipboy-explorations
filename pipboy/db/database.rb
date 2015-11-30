module Pipboy
  module DB
    class Database
      def initialize
        @entries = {}
      end

      def get(id)
        value = @entries[id]
        case value
        when Array #Arrays always seem to be lists of type Reference
          value.map {|obj_ref| get(obj_ref)}
        when Hash #Dictionaries always seem to be <String, Reference>
          Hash[value.map {|k, obj_ref| [k, get(obj_ref)]}]
        else
          value
        end
      end

      def set(id, value)
        @entries[id] = value
      end

      def set_dictionary(id, key, value)
        @entries[id] ||= {}
        @entries[id][key] = value
      end

      def remove_from_dictionary(id, reference)
        @entries[id] ||= {}
        @entries[id].delete_if {|k, r| r == reference}
      end

      def update(update)
        case update
        when Updates::Value
          set(update.ref, update.value)
        when Updates::Dictionary
          update.entries.each do |key, reference|
            set_dictionary(update.ref, key, reference)
          end
          update.removals.each do |reference|
            remove_from_dictionary(update.ref, reference)
          end
        end
      end
    end
  end
end
