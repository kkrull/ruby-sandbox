unless ARGV.length.eql? 1
  raise ArgumentError.new("Usage: %s <MIDI file>" % $0)
end

filename = ARGV[0]
file = File.open(filename, 'rb')

begin
  chunk_type = file.read 4
  chunk_length = file.read(4).unpack1("N")

  puts "%s: %d bytes" % [chunk_type, chunk_length]
ensure
  file.close
end
