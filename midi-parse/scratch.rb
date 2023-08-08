filename = 'data/drum-library-ezdrummer2.mid'

def read_chunk_header(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1('N')
end

def inspect_chunk(type_name, chunk_bytes, f)
  if 'MThd'.eql? type_name
    puts 'Header chunk'
    file_format = f.read 2
    puts "File format: %d" % [file_format.unpack1('n')]
    f.read(chunk_bytes - 2)
  else 
    f.read chunk_bytes
  end
end

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

