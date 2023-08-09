require_relative "./midi_file_header"

class MIDIFile
  ## Life cycle

  def self.open(filename)
    file = File.open(filename, "rb")
    MIDIFile.new file, MIDIFileHeader.read(file)
  end

  def initialize(file, file_header)
    @file = file
    @file_header = file_header
  end

  def close
    @file.close
  end

  def eof?
    @file.eof?
  end

  ## Contents

  def division_word
    @file_header.division
  end

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
    type_name, chunk_bytes = read_chunk_prefix @file
    @file.read chunk_bytes
    return type_name, chunk_bytes
  end
end

def read_chunk_prefix(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1("N")
end
