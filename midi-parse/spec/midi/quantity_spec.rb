require "rspec"
require "stringio"

require_relative "../../src/midi/quantity"

def make_byte_stream(bytes)
  return StringIO.new if bytes.empty?

  packed = bytes.pack("C*")
  StringIO.new packed
end

RSpec.describe Quantity do
  describe "::read" do
    context "given a stream already at EOF" do
      let(:io_stream) { make_byte_stream [] }

      it "reads 0 bytes" do
        returned = Quantity.read io_stream
        expect(io_stream.pos).to eql(0)
        expect(returned.num_bytes_read).to eql(0)
      end

      pending "#value is nil"
    end

    context "given a stream with a single byte quantity" do
      let(:io_stream) { make_byte_stream [0x7f] }

      it "consumes that byte from the stream" do
        returned = Quantity.read io_stream
        expect(io_stream.pos).to eql(1)
        expect(returned.num_bytes_read).to eql(1)
      end

      it "#value is the byte as-is" do
        returned = Quantity.read io_stream
        expect(returned.value).to eql(0x7f)
      end
    end

    context "given a stream headed with a 2-4 byte quantity" do
      let(:io_stream) { make_byte_stream [0x81, 0x00] }

      it "reads bytes until there is one with the MSB unset" do
        returned = Quantity.read io_stream
        expect(io_stream.pos).to eql(2)
        expect(returned.num_bytes_read).to eql(2)
      end

      #it "treats the remaining 7 LSB as data" do
      #  pending "add #value"
      #  returned = MIDI.read_variable_length_quantity io_stream
      #  expect(returned.value).to eql(0x80)
      #end
    end
  end
end
