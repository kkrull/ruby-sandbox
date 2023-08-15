require "rspec"

module MIDI
  module_function
  def read_variable_length_quantity()
  end
end

RSpec.describe MIDI do
  describe "::read_variable_length_quantity" do
    it "exists" do
      expect(MIDI).to respond_to(:read_variable_length_quantity)
    end
  end
end

