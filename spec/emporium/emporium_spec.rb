require 'spec_helper'

Emporium::Services::Amazon.configuration do |config|
  config.access_key = CONFIG["access_key"]
  config.associate_tag = CONFIG["associate_tag"]
  config.secret = CONFIG["secret"]
end

describe Emporium::Product do
  describe "#new" do
    it "creates an instance from a upc" do
      product = Emporium::Product.new("036000241457")
      product.should be_an_instance_of Emporium::Product
    end
    
    it "fails to create an instance if no upc is given" do
      lambda { Emporium::Product.new() }.should raise_error
    end
    
    it "fails to create an instance if invalid upc is given" do
      lambda { Emporium::Product.new("036000241452") }.should raise_error
    end
  end

  describe "#fetch!" do
    product = Emporium::Product.new("610839331574")
    product.use Emporium::Services::Amazon

    it "should fetch product information" do
      lambda { product.fetch! }.should_not raise_error
    end

    it "should create attributes for the product" do
      product.fetch!
      product.brand.should match 'Asus'
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
      options = {some: "option"}
      service = Emporium::Services::Amazon.new(options)
      service.instance_variable_get('@options')[:some].should match "option"
    end
  end

  describe "#response" do
    it "should return an XML document" do
      service = Emporium::Services::Amazon.new(code: "610839331574")
      service.response.should be_a_kind_of ::Nokogiri::XML::Document
    end

    it "should raise an error if nothing is found" do
      lambda { Emporium::Services::Amazon.new(code: "036000241452").response }.should raise_error
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
    