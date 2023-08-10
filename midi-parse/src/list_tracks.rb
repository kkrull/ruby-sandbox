require_relative "./midi/midi_file"

## Header chunk

def describe_header_chunk(midi_file)
  puts "File format: %s" % describe_file_format(midi_file)
  puts "Tracks: %d" % midi_file.num_tracks
  puts "Division %#04x: %s" % [midi_file.division_word, describe_division(midi_file.division_word)]
end

def describe_division(division)
  #https://midimusic.github.io/tech/midispec.html#BM2_1
  division_type = division & 0x8000
  case division_type
  when 0
    ticks_per_quarter = division & 0x7f00
    return "%d ticks per quarter note" % ticks_per_quarter
  else
    #[1] also possible
    raise ArgumentError.new("Unknown division type: %#04x" % division)
  end
end

def describe_file_format(midi_file)
  #https://midimusic.github.io/tech/midispec.html#BM2_1
  case
  when midi_file.single_track?
    "Single track, multi-channel (type %d)" % midi_file.file_format
  else
    #[1,2] also possible
    raise ArgumentError.new("Unknown MIDI file format: %d" % midi_file.file_format)
  end
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
  end
ensure
  midi_file.close
end
