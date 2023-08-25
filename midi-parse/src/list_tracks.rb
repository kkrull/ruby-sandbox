require_relative "./midi/midi_header_chunk"
require_relative "./midi/quantity"

unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
file = File.open(filename, "rb")

begin
  header = MIDIHeaderChunk.read(file)

  puts "Tracks: %d" % header.num_tracks
  while not file.eof?
    chunk = MIDIChunk.start_read file
    case
    when chunk.track?
      puts "Track (%d bytes)" % chunk.length

      quantity = Quantity.read file
      puts "Delta time: %#x" % quantity.value

      #TODO KDK: Read event
      file.read(chunk.length - quantity.num_bytes_read)
    else
      puts "Unknown chunk: %s (%d bytes)" % [chunk.type, chunk.length]
      file.read chunk.length
    end
  end
ensure
  file.close
end
