#The header chunk at the beginning of every MIDI file
class MIDIHeaderChunk
  def self.read(file)
    chunk = MIDIChunk.start_read file
    raise "Expected header chunk, but was %s" % chunk.type unless chunk.header?

    format = file.read(2).unpack1("n")
    num_tracks = file.read(2).unpack1("n")
    division = file.read(2).unpack1("n")
    MIDIHeaderChunk.new(format, num_tracks, division)
  end

  attr_reader :num_tracks

  def initialize(format, num_tracks, division)
    @num_tracks = num_tracks
  end
end

class MIDIChunk
  def self.start_read(file)
    chunk_type = file.read 4
    chunk_length = file.read(4).unpack1("N")
    MIDIChunk.new(chunk_type, chunk_length)
  end

  attr_reader :length, :type

  def initialize(type, length)
    @type = type
    @length = length
  end

  def header?
    @type.eql? "MThd"
  end

  def track?
    @type.eql? "MTrk"
  end
end
