unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
file = File.open(filename, 'rb')

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

  def is_header?
    @type.eql? "MThd"
  end
end

class MIDIHeaderChunk
  def self.read(file)
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

begin
  chunk = MIDIChunk.start_read file
  raise "Expected MThd chunk, but was %s" % chunk.type unless chunk.is_header?
  header = MIDIHeaderChunk.read(file)
  
  puts "Tracks: %d" % header.num_tracks
  while not file.eof?
    next_chunk = MIDIChunk.start_read file
    puts "%s: %d bytes" % [next_chunk.type, next_chunk.length]
    file.read next_chunk.length
  end
ensure
  file.close
end
