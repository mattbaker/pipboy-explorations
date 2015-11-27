require_relative "../../../pipboy/parser/primitive_readers"
require "minitest/autorun"
require 'stringio'

class TestPipboyPrimitiveReaders < Minitest::Test
  def setup
  end

  def test_bool
    trueByte = StringIO.new("\x1")
    falseByte = StringIO.new("\x0")
    assert_equal(true, Pipboy::Parser::PrimitiveReaders.bool(trueByte))
    assert_equal(false, Pipboy::Parser::PrimitiveReaders.bool(falseByte))
  end

  def test_sint8
    stream = StringIO.new("\xFF")
    assert_equal(-1, Pipboy::Parser::PrimitiveReaders.sint8(stream))
  end

  def test_uint8
    stream = StringIO.new("\xFF")
    assert_equal(255, Pipboy::Parser::PrimitiveReaders.uint8(stream))
  end

  def test_uint16
    stream = StringIO.new("\xFF\xFF")
    assert_equal(65535, Pipboy::Parser::PrimitiveReaders.uint16(stream))
  end

  def test_sint32
    stream = StringIO.new("\xFF\xFF\xFF\xFF")
    assert_equal(-1, Pipboy::Parser::PrimitiveReaders.sint32(stream))
  end

  def test_uint32
    stream = StringIO.new("\xFF\xFF\xFF\xFF")
    assert_equal(4294967295, Pipboy::Parser::PrimitiveReaders.uint32(stream))
  end

  def test_float32
    stream = StringIO.new("\x00\x00\x00\x40")
    assert_equal(2.0, Pipboy::Parser::PrimitiveReaders.float32(stream))
  end

  def test_string
    #Test null-terminated strings, this should cut off at HELLO
    stream = StringIO.new("HELLO\x00WORLD")
    assert_equal("HELLO", Pipboy::Parser::PrimitiveReaders.string(stream))
  end

  def test_reference
    stream = StringIO.new("\xFF\xFF\xFF\xFF")
    assert_equal(4294967295, Pipboy::Parser::PrimitiveReaders.reference(stream))
  end
end
