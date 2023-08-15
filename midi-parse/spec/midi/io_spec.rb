require "rspec"
require "stringio"

require_relative "../../src/midi/io" #Absolute import?

RSpec.describe MIDI do
  describe "::read_variable_length_quantity" do
    context "given a stream already at EOF" do
      let(:data) { StringIO.new }
      it "reads 0 bytes" do
        MIDI.read_variable_length_quantity data
        expect(data).not_to receive(:getbyte)
      end

      it "returns 0 bytes read, nil data" do
        returned = MIDI.read_variable_length_quantity data
        expect(returned).to eql([0, nil])
      end
    end

    pending "reads a byte for a single byte quantity"
  end
end
