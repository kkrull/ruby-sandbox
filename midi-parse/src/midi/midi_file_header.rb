class MIDIFileHeader
  def self.read(f)
    file_format = f.read(2).unpack1('n')
    num_tracks = f.read(2).unpack1('n')
    division = f.read(2).unpack1('n')

    MIDIFileHeader.new(file_format, num_tracks, division)
  end

  attr_reader :file_format, :num_tracks, :division

  def initialize(file_format, num_tracks, division)
    @file_format = file_format
    @num_tracks = num_tracks
    @division = division
  end
end

