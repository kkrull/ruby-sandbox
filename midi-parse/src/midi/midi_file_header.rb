class MIDIFileHeader
  attr_reader :file_format, :num_tracks, :division

  def initialize(file_format, num_tracks, division)
    @file_format = file_format
    @num_tracks = num_tracks
    @division = division
  end
end

