require_relative "./midi_file_header"

class MIDIFile
  ## I/O life cycle

  def self.open(filename)
    f = File.open(filename, "rb")
    MIDIFile.new f
  end

  def initialize(f)
    @f = f
  end

  def close
    @f.close
  end

  def eof?
    @f.eof?
  end

  ## Contents

  def file_header
    MIDIFileHeader.read @f
  end

  def read_chunk
    type_name, chunk_bytes = read_chunk_prefix @f
    @f.read chunk_bytes
    return type_name, chunk_bytes
  end
end

def read_chunk_prefix(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1("N")
end
