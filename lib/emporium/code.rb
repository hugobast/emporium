module Emporium
  class Code
    attr_accessor :value
    
    def initialize(value)
      @value, @check_digit, @code = value, value[-1, 1].to_i, value.chop
      attach_methods!
    end
    
    def valid?
      return unless (@value =~ /^[0-9]+$/) != nil
      compute(@code.odds, @code.evens) == @check_digit
    end
    
  private
    def compute(odds, evens)
      # source http://en.wikipedia.org/wiki/Universal_Product_Code#Check_digits
      remainder = (odds.inject(:+) * 3 + evens.inject(:+)) % 10
      remainder == 0 ? remainder : 10 - remainder
    end
  
    def attach_methods!
      @code.instance_eval do
        def odds
          self.subset(/(.).?/)
        end
      
        def evens
          self.subset(/.(.)?/)
        end
      
        def subset(filter)
          self.scan(filter).flatten.map{ |s| s.to_i }
        end
      end
    end
  end
end