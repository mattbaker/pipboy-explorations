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

  def test_data_update_bool
    stream = StringIO.new("\x00\x0B\x00\x00\x00\x01")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: true}], msg)
  end

  def test_data_update_sint8
    stream = StringIO.new("\x01\x0B\x00\x00\x00\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: -1}], msg)
  end

  def test_data_update_uint8
    stream = StringIO.new("\x02\x0B\x00\x00\x00\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: 255}], msg)
  end

  def test_data_update_sint32
    stream = StringIO.new("\x03\x0B\x00\x00\x00\xFF\xFF\xFF\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: -1}], msg)
  end

  def test_data_update_uint32
    stream = StringIO.new("\x04\x0B\x00\x00\x00\xFF\xFF\xFF\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: 4294967295}], msg)
  end

  def test_data_update_float32
    stream = StringIO.new("\x05\x0B\x00\x00\x00\x00\x00\x00\x40")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: 2.0}], msg)
  end

  def test_data_update_string
    stream = StringIO.new("\x06\x0B\x00\x00\x00HELLO\x00WORLD")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: "HELLO"}], msg)
  end

  def test_data_update_list
    stream = StringIO.new("\x07\x0B\x00\x00\x00\x02\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([{set:11, value: [4294967295,33554431]}], msg)
  end

  def test_data_update_dict_update
  end
end
