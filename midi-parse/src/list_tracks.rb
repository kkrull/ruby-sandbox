require_relative "./midi/midi_file"

## Header chunk

def describe_header_chunk(midi_file)
  puts "File format: %s" % describe_file_format(midi_file)
  puts "Tracks: %d" % midi_file.num_tracks
  puts "Division %#04x: %s" % [midi_file.division_word, describe_division(midi_file)]
end

def describe_division(midi_file)
  unless midi_file.division_by_ticks?
    raise ArgumentError.new("Unknown division type: %#04x" % midi_file.division_word)
  end

  "%d ticks per quarter note" % midi_file.division_ticks_per_quarter
end

def describe_file_format(midi_file)
  unless midi_file.single_track?
    raise ArgumentError.new("Unknown MIDI file format: %d" % midi_file.file_format)
  end

  "Single track, multi-channel (type %d)" % midi_file.file_format
end

## Main

unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
midi_file = MIDIFile.open(filename)

begin
  describe_header_chunk midi_file

  puts ""
  puts "Chunks"
  midi_file.read_chunks.each do |chunk|
    puts "%s: %s bytes" % [chunk.type_name, chunk.length]
    #if chunk.is_track?
    #  #read the variable length time
    #end
  end
ensure
  midi_file.close
end
