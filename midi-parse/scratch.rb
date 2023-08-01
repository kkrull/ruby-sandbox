filename = 'data/drum-library-ezdrummer2.mid'
f = File.open filename, 'rb'
begin
  contents = f.read
  puts contents[0,4]
ensure
  f.close
end

