class Quantity
  def self.read(io_stream)
    Quantity.new 0
  end

  attr_reader :num_bytes_read

  def initialize(num_bytes_read)
    @num_bytes_read = num_bytes_read
  end
end
