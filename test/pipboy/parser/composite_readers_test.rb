require_relative "../../../pipboy/parser/primitive_readers"
require_relative "../../../pipboy/parser/composite_readers"
require "minitest/autorun"
require 'stringio'

class TestPipboyCompositeReaders < Minitest::Test
  def setup
  end

  def test_header
    headerBytes = StringIO.new("\xA0\x00\x00\x00\x03")
    assert_equal([160,3], Pipboy::Parser::CompositeReaders.header(headerBytes))
  end

  def test_list
    primitiveReaders = Pipboy::Parser::PrimitiveReaders
    streamBytes = StringIO.new("\x03\x00\x00\x00\x03\x48\x45\x4C\x4C\x4F\x57\x4F\x52\x4C")
    assert_equal([1208156160, 1330400325, 1280462679], Pipboy::Parser::CompositeReaders.list(streamBytes, primitiveReaders, :uint32))
  end

  def test_dict_entry
    streamBytes = StringIO.new("\xA0\x00\x00\x00\x03\x48\x45\x4C\x4C\x4F\x57\x4F\x52\x4C\x44")
    assert_equal({"\u0003HELLOWORLD" => 160}, Pipboy::Parser::CompositeReaders.dict_entry(streamBytes))
  end

  def test_dict_update
  end
end
