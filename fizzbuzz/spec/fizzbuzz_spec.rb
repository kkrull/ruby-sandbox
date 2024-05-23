require 'fizzbuzz.rb'

describe FizzBuzz do
  describe '#fizz_buzz' do
    subject { FizzBuzz.new }

    it 'prints space-delimited string representations of each integer up to the number specified' do
      text = subject.fizz_buzz 2
      expect(text).to eql '1 2'
    end
    it 'prints multiples of 3 as "fizz"' do
      text = subject.fizz_buzz 6
      expect(text).to eql '1 2 fizz 4 buzz fizz'
    end
    it 'prints multiples of 5 as "buzz"' do
      text = subject.fizz_buzz 10
      expect(text).to eql '1 2 fizz 4 buzz fizz 7 8 fizz buzz'
    end
    it 'prints multiples of 3 and 5 as "fizzbuzz"' do
      text = subject.fizz_buzz 30
      expect(text).to match /fizzbuzz$/
    end
  end
end

