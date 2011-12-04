require 'spec_helper'

describe Product do
  describe "#new" do
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

    it "has options in options if provided" do
      product = Product.new("036000241457", secret: 'secret')
      product.instance_eval { @options[:secret] }.should match 'secret'
    end
  end

  describe "#fetch!" do
    product = Product.new("610839331574", access_key: CONFIG["access_key"], 
                                            associate_tag: CONFIG["associate_tag"], 
                                            secret: CONFIG["secret"])
    product.use :amazon

    it "should fetch product information" do
      product = Product.new("610839331574", access_key: CONFIG["access_key"], 
                                            associate_tag: CONFIG["associate_tag"], 
                                            secret: CONFIG["secret"])
      product.use :amazon
      lambda { product.fetch! }.should_not raise_error
    end

    it "should create attributes for the product" do
      product.fetch!
      product.manufacturer.should match 'Asus'
    end

  end
end

describe Code do
  describe "#valid?" do
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
    