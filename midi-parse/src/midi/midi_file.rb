require_relative "./io"
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

  ## Divisions of time

  def division_ticks_per_quarter
    unless division_by_ticks?
      raise ArgumentError.new("Unknown division type: %#04x" % division_word)
    end

    return division_word & 0x7f00
  end

  def division_by_ticks?
    #[1] also possible
    division_type.eql? 0
  end

  def division_type
    division_word & 0x8000
  end

  def division_word
    #https://midimusic.github.io/tech/midispec.html#BM2_1
    @file_header.division
  end

  ## File format

  def single_track?
    #[1,2] also possible
    @file_header.file_format.eql? 0
  end

  def file_format
    #https://midimusic.github.io/tech/midispec.html#BM2_1
    @file_header.file_format
  end

  ## Track chunks

  def num_tracks
    @file_header.num_tracks
  end

  ## Content

  def read_chunks
    chunks = []
    while not eof?
      chunk = MIDIChunk.read @file
      chunks.push chunk
    end

    chunks
  end

  private
  attr_reader :file_header
end

class MIDIChunk
  def self.read(file)
    type_name, chunk_bytes = MIDI::IO.read_chunk_prefix file
    file.read chunk_bytes
    MIDIChunk.new(type_name, chunk_bytes)
  end

  attr_reader :type_name, :length

  def initialize(type_name, length)
    @type_name = type_name
    @length = length
  end
end

