require_relative "./midi/midi_header_chunk"

unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
file = File.open(filename, 'rb')

begin
  header = MIDIHeaderChunk.read(file)

  puts "Tracks: %d" % header.num_tracks
  while not file.eof?
    chunk = MIDIChunk.start_read file
    case
    when chunk.is_track?
      puts "Track (%d bytes)" % chunk.length

      quantity, num_bytes = read_variable_length_quantity file

      #delta_time_bytes = []
      #var_length_byte = file.readchar.unpack1("c")
      #Use unpacks: { c 8-bit, n 16-bit, N 32-bit }

      file.read(chunk.length - num_bytes)
    else
      puts "Unknown chunk: %s (%d bytes)" % [chunk.type, chunk.length]
      file.read chunk.length
    end
  end
ensure
  file.close
end
