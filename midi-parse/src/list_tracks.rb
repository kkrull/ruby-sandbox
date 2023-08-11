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
end

begin
  chunk = MIDIChunk.start_read file
  puts "%s: %d bytes" % [chunk.type, chunk.length]

  file.read(2) #format
  num_tracks = file.read(2).unpack1("n")
  file.read(2) #division
  puts "Tracks: %d" % num_tracks
ensure
  file.close
end
