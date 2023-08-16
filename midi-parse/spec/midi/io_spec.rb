require "rspec"
require "stringio"

require_relative "../../src/midi/io" #Absolute import?

RSpec.describe MIDI do
  describe "::read_variable_length_quantity" do
    context "given a stream already at EOF" do
      let(:io_stream) { StringIO.new }
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
      let(:io_stream) { StringIO.new [0x7f].pack("C") }
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
  end
end
