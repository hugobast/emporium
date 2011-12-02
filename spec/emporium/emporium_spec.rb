require 'spec_helper'

access_key = CONFIG["access_key"]
secret = CONFIG["secret"]
associate_tag = CONFIG["associate_tag"]

include Emporium
describe Product do
  describe ".new" do
    it "creates an instance from a upc" do
      product = Product.new("036000241457")
      product.should be_an_instance_of Product
    end
    
    it "fails to create an instance if no upc is given" do
      lambda { Product.new() }.should raise_error
    end
    
    it "fails to create an instance if invalid upc is given" do
      lambda { Product.new("036000241452") }.should raise_error
    end

    it "has an option in options if provided" do
      product = Product.new("036000241457", secret: 'secret')
      product.instance_eval { @options[:secret] }.should match 'secret'
    end
  end

  describe ".fetch" do
    it "returns a Nokogiri XML object" do
      product = Product.new("610839331574", access_key: access_key, 
                                            associate_tag: associate_tag, 
                                            secret: secret)
      product.use :amazon
      product.fetch
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
    