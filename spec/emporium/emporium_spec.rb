require 'spec_helper'

include Emporium
describe Product do
  describe ".new" do
    it "creates an instance from a upc" do
      code = Product.new("036000241457")
      code.should be_an_instance_of Product
    end
    
    it "fails to create an instance if no upc is given" do
      lambda { Product.new() }.should raise_error
    end
    
    it "fails to create an instance if invalid upc is given" do
      lambda { Product.new("036000241452") }.should raise_error
    end
  end
end

describe Code do
  describe ".valid?" do
    it "returns true for a valid UPC" do
      code = Code.new("036000241457")
      code.valid?.should be true
    end
    
    it "returns false for an invalid UPC" do
      code = Code.new("036000241452")
      code.valid?.should_not be true
    end
  end
end
    