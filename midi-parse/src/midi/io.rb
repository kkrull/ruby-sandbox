module MIDI
  module_function

  def read_variable_length_quantity(io_stream)
    return Quantity.nothing_read if io_stream.eof?

    bytes = []
    loop do
      bytes.push io_stream.readbyte
      #puts "Read byte: %x" % byte
      break unless (bytes.last & 0x80).eql? 0x80
    end

    return Quantity.new(bytes.length, bytes[0])
  end

  class Quantity
    def self.nothing_read
      Quantity.new(0, nil)
    end

    attr_reader :num_bytes_read, :data

    def initialize(num_bytes_read, data)
      @num_bytes_read = num_bytes_read
      @data = data
    end
  end
end
