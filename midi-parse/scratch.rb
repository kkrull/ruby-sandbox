filename = 'data/drum-library-ezdrummer2.mid'
f = File.open filename, 'rb'
contents = f.read
f.close

puts contents[0,4]
