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
    streamBytes = StringIO.new("\xA0\x00\x00\x00\x03\x48\x45\x4C\x4C\x4F\x57\x4F\x52\x4C\x44\x70\x69\x70\x62\x6f\x79\x00\x00\x00\x00\x00")
    assert_equal({"\u0003HELLOWORLDpipboy" => 160}, Pipboy::Parser::CompositeReaders.dict_entry(streamBytes))
  end

  def test_dict_update
    streamBytes = StringIO.new("\x23\x00\x00\x00\x01\x7b\x22\x6c\x61\x6e\x67\x22\x3a\x22\x65\x6e\x22\x2c\x22\x76\x65\x72\x73\x69\x6f\x6e\x22\x3a\x22\x31\x2e\x31\x2e\x32\x31\x2e\x30\x22\x7d\x0a\xd6\x81\x07\x00\x03\x06\x6f\x7f\x00\x00\x24\x47\x65\x6e\x65\x72\x61\x6c\x00\x03\x7f\x7f")
    assert_equal({:updates=>[{"ELLOWORLDpipboy"=>1208156160}], :removals=>[]}, Pipboy::Parser::CompositeReaders.dict_update(streamBytes))
  end
end
