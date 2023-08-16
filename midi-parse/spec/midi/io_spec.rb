require "rspec"
require "stringio"

require_relative "../../src/midi/io" #Absolute import?

def make_byte_stream(bytes)
  return StringIO.new if bytes.empty?

  packed = bytes.pack("C*")
  StringIO.new packed
end

#TODO KDK: Change to Quantity::read with #num_bytes, #data, and #value
RSpec.describe MIDI do
  describe "::read_variable_length_quantity" do
    context "given a stream already at EOF" do
      let(:io_stream) { make_byte_stream [] }
      it "reads 0 bytes" do
        expect(io_stream).not_to receive(:getbyte)
        MIDI.read_variable_length_quantity io_stream
      end

      it "returns 0 bytes read, nil data" do
        returned = MIDI.read_variable_length_quantity io_stream
        expect(returned.num_bytes_read).to eql(0)
        expect(returned.data).to be_nil
      end
    end

    context "given a stream headed by a single byte quantity" do
      let(:io_stream) { make_byte_stream [0x7f] }
      it "returns that single byte of data" do
        returned = MIDI.read_variable_length_quantity io_stream
        expect(returned.num_bytes_read).to eql(1)
        expect(returned.data).to eql(0x7f)
      end

      it "consumes that byte from the stream" do
        returned = MIDI.read_variable_length_quantity io_stream
        expect(io_stream.eof?).to be(true)
      end
    end

    context "given a stream headed by a 2-4 byte quantity" do
      let(:io_stream) { make_byte_stream [0x81, 0x00] }
      it "reads bytes until there is one with the MSB unset" do
        returned = MIDI.read_variable_length_quantity io_stream
        expect(returned.num_bytes_read).to eql(2)
        expect(io_stream.pos).to eql(2)
      end

      pending "treats the remaining 7 LSB as data" do
        returned = MIDI.read_variable_length_quantity io_stream
        expect(returned.quantity).to eql(0x80)
      end
    end
  end
end
