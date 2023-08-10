require_relative "./midi_file_header"

#Top-level object for parsing musical instrument data in a MIDI file
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

  ## File header

  def division_word
    @file_header.division
  end

  def file_format
    @file_header.file_format
  end

  def num_tracks
    @file_header.num_tracks
  end

  def single_track?
    @file_header.file_format.eql? 0
  end

  ## Content

  def read_chunks
    chunks = []
    while not eof?
      type_name, chunk_bytes = read_chunk
      chunks.push MIDIChunk.new(type_name, chunk_bytes)
    end

    chunks
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

def read_chunk_prefix(file)
  type_name = file.read 4
  chunk_bytes = file.read 4
  return type_name, chunk_bytes.unpack1("N")
end

class MIDIChunk
  attr_reader :type_name, :length

  def initialize(type_name, length)
    @type_name = type_name
    @length = length
  end
end

