require_relative "../../pipboy/message"
require "minitest/autorun"
require 'stringio'

class TestPipboyMessage < Minitest::Test
  def setup
  end

  def test_from_stream
    fake_stream = StringIO.new("\xA0\x00\x00\x00\x01HELLOWORLD")
    message = Pipboy::Message.from_stream(fake_stream)
    assert_equal("HELLOWORLD", message.body)
    assert_equal(:CONNECTION_ACCEPTED, message.type)
  end
end
