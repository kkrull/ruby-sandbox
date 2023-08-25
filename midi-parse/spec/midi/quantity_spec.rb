require "rspec"
require "stringio"

require_relative "../../src/midi/quantity"

RSpec.describe Quantity do
  describe "::read" do
    context "given a stream already at EOF" do
      it "reads 0 bytes" do
        io_stream = make_byte_stream []
        Quantity.read io_stream
        expect(io_stream.pos).to eql(0)
      end
    end

    context "given a stream with a single byte quantity (MSB clear)" do
      let(:io_stream) { make_byte_stream [0x7f] }

      it "consumes that byte from the stream" do
        Quantity.read io_stream
        expect(io_stream.pos).to eql(1)
      end

      it "decodes that byte as-is" do
        subject = Quantity.read io_stream
        expect(subject.value).to eql(0x7f)
      end
    end

    context "given a stream headed with a multi-byte quantity" do
      let(:io_stream) { make_byte_stream [0x81, 0x00] }

      it "reads bytes until there is one with the MSB clear" do
        Quantity.read io_stream
        expect(io_stream.pos).to eql(2)
      end

      #it "treats the remaining 7 LSB as data" do
      #  pending "add #value"
      #  returned = MIDI.read_variable_length_quantity io_stream
      #  expect(returned.value).to eql(0x80)
      #end
    end
  end

  describe '#num_bytes_read' do
    it "is 0, given a stream already at EOF" do
      io_stream = make_byte_stream []
      subject = Quantity.read io_stream
      expect(subject.num_bytes_read).to eql(0)
    end

    it "is however many bytes were read from the stream during ::read" do
      io_stream = make_byte_stream [0x42]
      subject = Quantity.read io_stream
      expect(subject.num_bytes_read).to eql(1)
    end
  end

  describe '#value' do
    it "is nil, given a stream already at EOF" do
      io_stream = make_byte_stream []
      subject = Quantity.read io_stream
      expect(subject.value).to be_nil
    end

    it "is the number decoded from the stream during ::read" do
      io_stream = make_byte_stream [0x2a]
      subject = Quantity.read io_stream
      expect(subject.value).to eql(42)
    end
  end
end

def make_byte_stream(bytes)
  return StringIO.new if bytes.empty?

  packed = bytes.pack("C*")
  StringIO.new packed
end
