module MIDI
  module_function

  def read_variable_length_quantity(str_io)
    return [0, nil] # if str_io.eof?
    #byte = str_io.readbyte
  end
end

