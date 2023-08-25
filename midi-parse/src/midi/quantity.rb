class Quantity
  def self.read(io_stream)
    return Quantity.new(0, 0) if io_stream.eof?

    data = []
    data << io_stream.readbyte
    Quantity.new data.length, data[0]
  end

  attr_reader :num_bytes_read, :value

  def initialize(num_bytes_read, value)
    @num_bytes_read = num_bytes_read
    @value = value
  end
end
