require 'spec_helper'

Emporium::Services::Amazon.configuration do |config|
  config.access_key = AMAZON["access_key"]
  config.associate_tag = AMAZON["associate_tag"]
  config.secret = AMAZON["secret"]
end

Emporium::Services::Google.configuration do |config|
  config.access_key = GOOGLE["access_key"]
  config.cse = GOOGLE["cse"]
end

describe Emporium::Product do
  describe "#new" do
    it "fails to create an instance if no upc is given" do
      lambda { Emporium::Product.new() }.should raise_error
    end
    
    it "fails to create an instance if invalid upc is given" do
      lambda { Emporium::Product.new("036000241452") }.should raise_error
    end
  end

  describe "#fetch!" do
    product = Emporium::Product.new("610839331574")

    describe "using the amazon service" do
      product.use Emporium::Services::Amazon

      it "should fetch product information" do
        lambda { product.fetch! }.should_not raise_error
      end

      it "should create attributes for the product" do
        product.fetch!
        product.brand.downcase.should match 'asus'
      end
    end

    describe "using the google service" do
      product.use Emporium::Services::Google
      
      it "should fetch product information" do
        lambda { product.fetch! }.should_not raise_error
      end

      it "should create attributes for the product" do
        product.fetch!
        product.brand.downcase.should match 'asus'
      end
    end

  end

  describe "#use" do
    it "tells a product what service to use" do
      product = Emporium::Product.new("610839331574")
      product.use Emporium::Services::Amazon
      product.service.should be_an_instance_of Emporium::Services::Amazon
    end
  end
end

describe Emporium::Services::Amazon do
  describe "#new" do
    it "should initialize with options" do
      options = { some: "option" }
      service = Emporium::Services::Amazon.new(options)
      service.instance_variable_get('@options')[:some].should match "option"
    end
  end

  describe "#response" do
    it "should return a Hash" do
      service = Emporium::Services::Amazon.new(code: "610839331574")
      service.response.should be_an_instance_of Hash
    end

    it "should raise an error if nothing is found" do
      lambda {
        Emporium::Services::Amazon.new(code: "036000241452").response
      }.should raise_error
    end
  end
end

describe Emporium::Services::Google do
  describe "#new" do
    it "should initialize with options" do
      options = { some: "option" }
      service = Emporium::Services::Amazon.new(options)
      service.instance_variable_get('@options')[:some].should match "option"
    end
  end

  describe "#response" do
    it "should return a Hash" do
      service = Emporium::Services::Google.new(code: "610839331574")
      service.response.should be_an_instance_of Hash
    end

    it "should return an error if nothing is found" do
      lambda {
        service = Emporium::Services::Google.new(code: "ASjh@89a2$").response
      }.should raise_error
    end
  end
end

describe Emporium::Code do
  describe "#valid?" do
    it "returns true for a valid UPC" do
      code = Emporium::Code.new("036000241457")
      code.valid?.should be true
    end
    
    it "returns false for an invalid UPC" do
      code = Emporium::Code.new("036000241452")
      code.valid?.should_not be true
    end
  end
end
    