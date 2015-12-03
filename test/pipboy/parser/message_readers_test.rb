require "minitest/autorun"
require 'stringio'
require_relative "../../../pipboy/parser/message_readers"
require_relative "../../../pipboy/db/updates"

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
    assert_equal([Pipboy::DB::Updates::Value.new(11, true)], msg)
  end

  def test_data_update_sint8
    stream = StringIO.new("\x01\x0B\x00\x00\x00\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, -1)], msg)
  end

  def test_data_update_uint8
    stream = StringIO.new("\x02\x0B\x00\x00\x00\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, 255)], msg)
  end

  def test_data_update_sint32
    stream = StringIO.new("\x03\x0B\x00\x00\x00\xFF\xFF\xFF\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, -1)], msg)
  end

  def test_data_update_uint32
    stream = StringIO.new("\x04\x0B\x00\x00\x00\xFF\xFF\xFF\xFF")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, 4294967295)], msg)
  end

  def test_data_update_float32
    stream = StringIO.new("\x05\x0B\x00\x00\x00\x00\x00\x00\x40")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, 2.0)], msg)
  end

  def test_data_update_string
    stream = StringIO.new("\x06\x0B\x00\x00\x00HELLO\x00WORLD")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, "HELLO")], msg)
  end

  def test_data_update_list
    stream = StringIO.new("\x07\x0B\x00\x00\x00\x02\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x01")
    msg = Pipboy::Parser::MessageReaders.data_update(stream, 6)
    assert_equal([Pipboy::DB::Updates::Value.new(11, [4294967295,33554431])], msg)
  end

  def test_data_update_dict
    type = "\x08"
    ref = "\x0B\x00\x00\x00"
    updates_length = "\x02\x00"
    dict_entry_1 = "\x03\x00\x00\x00\x66\x6f\x6f\x00"
    dict_entry_2 = "\x04\x00\x00\x00\x62\x61\x72\x00"
    removal_length = "\x02\x00"
    references_to_remove = "\x01\x00\x00\x00\x02\x00\x00\x00"
    stream = StringIO.new(type+ref+updates_length+dict_entry_1+dict_entry_2+removal_length+references_to_remove)
    msg = Pipboy::Parser::MessageReaders.data_update(stream, stream.length)
    assert_equal([Pipboy::DB::Updates::Dictionary.new(11, [["foo",3],["bar",4]], [1,2])], msg)
  end
end
