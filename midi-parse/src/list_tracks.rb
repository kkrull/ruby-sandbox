require_relative "./midi/midi_file"

## File -> chunks

def describe_chunk(type_name)
  case type_name
  when "MThd"
    "Header chunk"
  when "MTrk"
    "Track chunk"
  else
    "Unknown chunk"
  end
end

## Header chunk

def describe_header_chunk(mf)
  puts "File format %d: %s" % [mf.file_format, describe_file_format(mf.file_format)]
  puts "Tracks: %d" % [mf.num_tracks]
  puts "Division %#04x: %s" % [mf.division_word, describe_division(mf.division_word)]
end

def describe_division(division)
  #https://midimusic.github.io/tech/midispec.html#BM2_1
  division_type = division & 0x8000
  case division_type
  when 0
    ticks_per_quarter = division & 0x7f00
    return "%d ticks per quarter note" % [ticks_per_quarter]
  else
    #[1] also possible
    raise ArgumentError.new("Unknown division type: %#04x" % division)
  end
end

def describe_file_format(id)
  #https://midimusic.github.io/tech/midispec.html#BM2_1
  case id
  when 0
    return "Single track, multi-channel"
  else
    #[1,2] also possible
    raise ArgumentError.new("Unknown MIDI file format: %d" % [id])
  end
end

## Main

unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
mf = MIDIFile.open(filename)

begin
  #Start with the header chunk, which is always first
  file_header = mf.file_header
  puts "Header chunk"
  describe_header_chunk mf

  #Then read the tracks and any other chunk
  while not mf.eof?
    type_name, chunk_bytes = mf.read_chunk
    puts ""
    puts "%s: %s bytes" % [type_name, chunk_bytes]
    puts describe_chunk(type_name)
  end
ensure
  mf.close
end
