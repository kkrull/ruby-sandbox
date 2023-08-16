module MIDI
  module_function

  def read_variable_length_quantity(io_stream)
    return Quantity.nothing_read
    #return [0, nil] # if str_io.eof?
    #byte = str_io.readbyte
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

