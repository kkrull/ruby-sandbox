#Variable length quantity, encoded as 7-bit values in up to 4 bytes
#Format: [0b1VVVVVVV]* 0b0VVVVVVV
#Bit 7 (Flag): Set (more bytes in sequence), Clear (last byte in sequence)
#Bits 0-6: Value
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
