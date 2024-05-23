class FizzBuzz
  def fizz_buzz(last_num)
    text = ''
    (1..last_num).each do |x|
      if x == 1
        text << x.to_s
      elsif x % 3 == 0 && x % 5 == 0
        text << ' fizzbuzz'
      elsif x % 3 == 0
        text << ' fizz'
      elsif x % 5 == 0
        text << ' buzz'
      else
        text << " #{x}"
      end
    end

    text
  end
end

