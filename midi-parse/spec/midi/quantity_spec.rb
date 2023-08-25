require "rspec"
require "stringio"

require_relative "../../src/midi/io" #Absolute import?

def make_byte_stream(bytes)
  return StringIO.new if bytes.empty?

  packed = bytes.pack("C*")
  StringIO.new packed
end

class Quantity
  def self.read(io_stream)
    Quantity.new 0
  end

  attr_reader :num_bytes_read

  def initialize(num_bytes_read)
    @num_bytes_read = num_bytes_read
  end
end

RSpec.describe Quantity do
  describe '::read' do
    context "given a stream already at EOF" do
      let(:io_stream) { make_byte_stream [] }

      it "reads 0 bytes" do
        expect(io_stream.pos).to eql(0)
        Quantity.read io_stream
      end
    end

    describe "#num_bytes_read" do
      context "when read from a stream already at EOF" do
        let(:io_stream) { make_byte_stream [] }

        it "returns 0 bytes read, nil data" do
          returned = Quantity.read io_stream
          expect(returned.num_bytes_read).to eql(0)
        end
      end
    end
  end
end
