#The first chunk in a MIDI file, stating how the following chunks are organized
class MIDIFileHeader
  def self.read(file)
    type_name, chunk_bytes = read_chunk_prefix file
    unless type_name.eql? "MThd"
      raise "Expected first chunk to be a header chunk, but was: %s" % type_name
    end
    unless chunk_bytes.eql? 6
      raise "Unexpected MThd chunk size: %d" % chunk_bytes
    end

    file_format = file.read(2).unpack1("n")
    num_tracks = file.read(2).unpack1("n")
    division = file.read(2).unpack1("n")
    MIDIFileHeader.new(file_format, num_tracks, division)
  end

  attr_reader :file_format, :num_tracks, :division

  def initialize(file_format, num_tracks, division)
    @file_format = file_format
    @num_tracks = num_tracks
    @division = division
  end
end
