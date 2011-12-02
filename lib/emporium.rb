require "emporium/version"

module Emporium
  class Product
    
    def initialize(code)
      @code = code
    end
  end
  
  class Code
    def initialize(value)
      @value = value
    end
    
    def valid?
      return unless (@value =~ /^[0-9]+$/) != nil
      check_digit, code = @value[-1, 1], @value.chop
      odd_operation = code.scan(/(.).?/).flatten.map{ |s| s.to_i }.inject(:+) * 3
      even_operation = code.scan(/.(.)?/).flatten.map{ |s| s.to_i }.inject(:+)
      10 - (odd_operation + even_operation) % 10 == check_digit.to_i
    end
  end
end
