require_relative "../../../pipboy/parser/message_readers"
require "minitest/autorun"
require 'stringio'

class TestPipboyMessageReaders < Minitest::Test
  def setup
  end

  def test_connection_accepted
    version_str = '{"version":"1.0", "lang":"en"}'
    version_stream = StringIO.new(version_str)
    msg = Pipboy::Parser::MessageReaders.connection_accepted(version_stream, version_str.length)
    assert_equal({"version" => "1.0", "lang" => "en"}, msg)
  end
end
