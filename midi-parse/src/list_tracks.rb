require_relative './midi/midi_file'
require_relative './midi/midi_file_header'

## File -> chunks

def read_chunk_prefix(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1('N')
end

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

def inspect_header_chunk(chunk_bytes, f)
  file_header = read_header_chunk f

  puts "File format %d: %s" % [file_header.file_format, describe_file_format(file_header.file_format)]
  puts "Tracks: %d" % [file_header.num_tracks]
  puts "Division %#04x: %s" % [file_header.division, describe_division(file_header.division)]
end

def read_header_chunk(f)
  file_format = f.read(2).unpack1('n')
  num_tracks = f.read(2).unpack1('n')
  division = f.read(2).unpack1('n')

  MIDIFileHeader.new(file_format, num_tracks, division)
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
  type_name, chunk_bytes = read_chunk_prefix f
  unless type_name.eql? 'MThd'
    raise 'Expected first chunk to be a header chunk, but was: %s' % [type_name]
  end

  puts 'Header chunk'
  inspect_header_chunk chunk_bytes, f

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

