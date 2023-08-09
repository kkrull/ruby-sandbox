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

