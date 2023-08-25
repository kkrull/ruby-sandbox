class Quantity
  def self.read(io_stream)
    return Quantity.new(0, nil) if io_stream.eof?

    data = []
    value = 0
    loop do
      byte = io_stream.readbyte
      data << byte
      value = (value << 7) + (byte & 0x7f)
      break unless (byte & 0x80).eql? 0x80
    end

    Quantity.new data.length, value
  end

  attr_reader :num_bytes_read, :value

  def initialize(num_bytes_read, value)
    @num_bytes_read = num_bytes_read
    @value = value
  end
end
