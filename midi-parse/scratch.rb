filename = 'data/drum-library-ezdrummer2.mid'

def read_chunk(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1('N')
end

f = File.open filename, 'rb'
begin
  type_name, chunk_bytes = read_chunk f
  puts "%s: %s bytes" % [type_name, chunk_bytes]
ensure
  f.close
end

