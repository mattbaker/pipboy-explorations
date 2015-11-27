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

      def keep_alive(stream)
        "KEEP ALIVE"
      end
    end
  end
end
