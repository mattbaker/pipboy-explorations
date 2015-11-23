require_relative "../../pipboy/message"
require "minitest/autorun"
require 'stringio'

class TestPipboyMessage < Minitest::Test
  def setup
  end

  def test_from_stream
    fake_stream = StringIO.new("\x0A\x00\x00\x00\x01HELLOWORLD---------")
    message = Pipboy::Message.from_stream(fake_stream)
    assert_equal("HELLOWORLD", message.body)
    assert_equal(:CONNECTION_ACCEPTED, message.type)
  end

  def test_to_bytes
    message = Pipboy::Message.new(3, "HOLAWORLD")
    assert_equal("\x09\x00\x00\x00\x03HOLAWORLD", message.to_bytes)
  end

  def test_hex_body
    message = Pipboy::Message.new(3, "\xF\xA\xC\xE")
    assert_equal("0F0A0C0E", message.hex_body)
  end
end
