require_relative "./midi_file_header"

class MIDIFile
  ## Life cycle

  def self.open(filename)
    f = File.open(filename, "rb")
    MIDIFile.new f, MIDIFileHeader.read(f)
  end

  def initialize(f, file_header)
    @f = f
    @file_header = file_header
  end

  def close
    @f.close
  end

  def eof?
    @f.eof?
  end

  ## Contents

  def file_format
    @file_header.file_format
  end

  def num_tracks
    @file_header.num_tracks
  end

#  private
  def file_header
    @file_header
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
