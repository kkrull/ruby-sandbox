class MIDIFile
  def self.open(filename)
    f = File.open(filename, 'rb')
    MIDIFile.new f
  end

  def initialize(f)
    @f = f
  end

  def close
    @f.close
  end
end

def read_chunk_prefix(f)
  type_name = f.read 4
  chunk_bytes = f.read 4
  return type_name, chunk_bytes.unpack1('N')
end
