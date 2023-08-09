require_relative './midi/midi_file'
require_relative './midi/midi_file_header'

## File -> chunks

def describe_chunk(type_name, chunk_bytes)
  case type_name
  when 'MThd'
    puts 'Header chunk'
  when 'MTrk'
    puts 'Track chunk'
  else
    puts 'Unknown chunk'
  end
end

## Header chunk

def describe_header_chunk(header)
  puts "File format %d: %s" % [header.file_format, describe_file_format(header.file_format)]
  puts "Tracks: %d" % [header.num_tracks]
  puts "Division %#04x: %s" % [header.division, describe_division(header.division)]
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
    raise ArgumentError.new('Unknown division type: %#04x' % division)
  end
end

def describe_file_format(id)
  #https://midimusic.github.io/tech/midispec.html#BM2_1
  case id
  when 0
    return "Single track, multi-channel"
  else
    #[1,2] also possible
    raise ArgumentError.new('Unknown MIDI file format: %d' % [id])
  end
end

## Main

unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]

f = File.open filename, 'rb'
begin
  #Start with the header chunk, which is always first
  file_header = MIDIFileHeader.read f
  puts 'Header chunk'
  describe_header_chunk file_header

  #Then read the tracks and any other chunk
  while not f.eof?
    type_name, chunk_bytes = read_chunk_prefix f
    puts ""
    puts "%s: %s bytes" % [type_name, chunk_bytes]

    describe_chunk type_name, chunk_bytes
    f.read chunk_bytes
  end
ensure
  f.close
end

