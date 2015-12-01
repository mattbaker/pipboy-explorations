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
    streamBytes = StringIO.new("\x03\x00\x00\x00\x03\x48\x45\x4C\x4C\x4F\x57\x4F\x52\x4C")
    list_readers = Pipboy::Parser::CompositeReaders.list(streamBytes, Pipboy::Parser::PrimitiveReaders, :uint32)
    assert_equal([1208156160, 1330400325, 1280462679], list_readers)
  end

  def test_dict_entry
    streamBytes = StringIO.new("\x15\x00\x00\x00\x44\x69\x63\x74\x69\x6f\x6e\x61\x72\x79\x45\x6e\x74\x72\x79\x54\x65\x73\x74\x3a\x29\x00")
    assert_equal({"DictionaryEntryTest:)"=>21}, Pipboy::Parser::CompositeReaders.dict_entry(streamBytes))
  end

  def test_dict_update
    streamBytes = StringIO.new("\x02\x00\x03\x00\x00\x00\x66\x6f\x6f\x00\x03\x00\x00\x00\x62\x61\x72\x00\x02\x00\x63\x61\x70\x74\x69\x61\x6e\x73\x63\x72\x75\x6e\x63\x68\x65\x73")
    dictionary_update = Pipboy::Parser::CompositeReaders.dict_update(streamBytes)
    assert_equal({:updates=>[{"foo"=>3}, {"bar"=>3}], :removals=>[1953522019, 1936613737]}, dictionary_update)
  end
end
