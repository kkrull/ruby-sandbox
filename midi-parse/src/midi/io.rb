module MIDI
  module IO
    module_function

    def read_chunk_prefix(file)
      type_name = file.read 4
      chunk_bytes = file.read 4
      return type_name, chunk_bytes.unpack1("N")
    end
  end
end

