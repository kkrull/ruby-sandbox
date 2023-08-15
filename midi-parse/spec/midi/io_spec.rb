require "rspec"

require "stringio"

module MIDI
  module_function

  def read_variable_length_quantity(str_io)
    return [0, nil] # if str_io.eof?
    #byte = str_io.readbyte
  end
end

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
  end
end
