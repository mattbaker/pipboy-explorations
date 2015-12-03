require_relative "../../../pipboy/parser/primitive_readers"
require_relative "../../../pipboy/parser/composite_readers"
require "minitest/autorun"
require 'stringio'

class TestPipboyCompositeReaders < Minitest::Test
  def setup
  end

  def test_header
    length = "\xA0\x00\x00\x00"
    type = "\x03"
    headerBytes = StringIO.new(length+type)
    assert_equal([160,3], Pipboy::Parser::CompositeReaders.header(headerBytes))
  end

  def test_list
    length = "\x03\x00"
    values = "\x01\x00\x00\x00\x02\x00\x00\x00\x03\x00\x00\x00"
    streamBytes = StringIO.new(length+values)
    list_readers = Pipboy::Parser::CompositeReaders.list(streamBytes, Pipboy::Parser::PrimitiveReaders, :uint32)
    assert_equal([1, 2, 3], list_readers)
  end

  def test_dict_entry
    value = "\x15\x00\x00\x00"
    key = "\x44\x69\x63\x74\x69\x6f\x6e\x61\x72\x79\x45\x6e\x74\x72\x79\x54\x65\x73\x74\x00"
    streamBytes = StringIO.new(value+key)
    assert_equal({"DictionaryEntryTest"=>21}, Pipboy::Parser::CompositeReaders.dict_entry(streamBytes))
  end

  def test_dict_update
    updates_length = "\x02\x00"
    dict_entry_1 = "\x03\x00\x00\x00\x66\x6f\x6f\x00"
    dict_entry_2 = "\x04\x00\x00\x00\x62\x61\x72\x00"
    removal_length = "\x02\x00"
    references_to_remove = "\x01\x00\x00\x00\x02\x00\x00\x00"
    streamBytes = StringIO.new(updates_length+dict_entry_1+dict_entry_2+removal_length+references_to_remove)
    dictionary_update = Pipboy::Parser::CompositeReaders.dict_update(streamBytes)
    assert_equal({:updates=>[{"foo"=>3}, {"bar"=>4}], :removals=>[1, 2]}, dictionary_update)
  end
end
