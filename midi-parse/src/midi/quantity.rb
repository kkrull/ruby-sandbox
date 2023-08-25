class Quantity
  def self.read(io_stream)
    return Quantity.new 0 if io_stream.eof?
    Quantity.new 999
  end

  attr_reader :num_bytes_read

  def initialize(num_bytes_read)
    @num_bytes_read = num_bytes_read
  end
end
