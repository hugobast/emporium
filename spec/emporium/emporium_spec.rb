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
    let(:product) { Emporium::Product.new("610839331574") }

    describe "using the amazon service" do
      before do
        product.service = :amazon
      end

      it "should fetch product information" do
        VCR.use_cassette("fetch_amazon") do
          lambda { product.fetch! }.should_not raise_error
        end
      end

      it "should create attributes for the product" do
        VCR.use_cassette("fetch_amazon") do
          product.fetch!
          product.brand.downcase.should match 'asus'
        end
      end
    end

    describe "using the google service" do
      before do
        product.service = :google
      end
      
      it "should fetch product information" do
        VCR.use_cassette("fetch_google") do
          lambda { product.fetch! }.should_not raise_error
        end
      end

      it "should create attributes for the product" do
        VCR.use_cassette("fetch_google") do
          product.fetch!
          product.brand.downcase.should match 'asus'
        end
      end
    end

  end

  describe "#service=" do
    it "tells a product what service to use" do
      product = Emporium::Product.new("610839331574")
      product.service = :amazon
      product.service.should be_an_instance_of Emporium::Services::Amazon
    end
  end
end

describe Emporium::Services::Amazon do
  it "should not modify every classes" do
    Class.methods.should_not include :access_key
  end

  describe "#new" do
    it "should initialize with options" do
      options = { some: "option" }
      service = Emporium::Services::Amazon.new(options)
      service.instance_variable_get('@options')[:some].should match "option"
    end
  end

  describe "#response" do
    it "should return a Hash" do
      VCR.use_cassette("fetch_amazon") do
        service = Emporium::Services::Amazon.new(code: "610839331574")
        service.response.should be_an_instance_of Hash
      end
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
      VCR.use_cassette("fetch_google") do
        service = Emporium::Services::Google.new(code: "610839331574")
        service.response.should be_an_instance_of Hash
      end
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
    
