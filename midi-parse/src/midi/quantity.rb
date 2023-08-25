class Quantity
  def self.read(io_stream)
    return Quantity.new(0, nil) if io_stream.eof?

    data = []
    value = 0
    loop do
      data << io_stream.readbyte
      value = (value << 7) + (data.last & 0x7f)
      break unless (data.last & 0x80).eql? 0x80
    end

    Quantity.new data.length, value
  end

  attr_reader :num_bytes_read, :value

  def initialize(num_bytes_read, value)
    @num_bytes_read = num_bytes_read
    @value = value
  end
end
