## File -> chunks

def read_chunk_header(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1('N')
end

def inspect_chunk(type_name, chunk_bytes, f)
  case type_name
  when 'MThd'
    puts 'Header chunk'
    inspect_header_chunk chunk_bytes, f
  else
    f.read chunk_bytes
  end
end

## Header chunk

def inspect_header_chunk(chunk_bytes, f)
  file_format = f.read(2).unpack1('n')
  puts "File format: %s (%d)" % [describe_file_format(file_format), file_format]

  num_tracks = f.read(2).unpack1('n')
  puts "Tracks: %d" % [num_tracks]
  f.read(chunk_bytes - 4)
end

def describe_file_format(id)
  case id
  when 0
    return "Single track, multi-channel"
  else
    #[1,2] also possible: https://midimusic.github.io/tech/midispec.html#BM2_1
    raise ArgumentError.new('Unknown MIDI file format: %d' % [id])
  end
end

## Main

filename = 'data/drum-library-ezdrummer2.mid'

f = File.open filename, 'rb'
begin
  while not f.eof?
    type_name, chunk_bytes = read_chunk_header f
    puts ""
    puts "%s: %s bytes" % [type_name, chunk_bytes]

    inspect_chunk type_name, chunk_bytes, f
  end
ensure
  f.close
end

