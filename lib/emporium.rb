require "emporium/version"

require 'hmac'
require 'hmac-sha2'
require 'time'
require 'cgi'
require 'base64'
require 'nokogiri'
require 'open-uri'

module Emporium
  class Product
    attr_accessor :code
    
    def initialize(code, options={})
      @code = ::Code.new(code)
      raise "invalid code" unless @code.valid?
      @options = options.merge! code: @code.value
    end
    
    def fetch
      if @service && @service == :amazon
        ::Nokogiri::XML(open("http://webservices.amazon.com/onca/xml?#{signed_query}"))
      end
    end

    def use(service)
      @service = service
    end
    
  private
  
    def params
      {
        "Service" => "AWSECommerceService",
        "Operation" => "ItemLookup",
        "IdType" => "UPC",
        "ItemId" => @code.value,
        "SearchIndex" => @options[:search_index] || "All",
        "ResponseGroup" => @options[:response_group] || "Medium",
        "Version" => @options[:version] || "2011-08-01",
        "AssociateTag" => @options[:associate_tag],
        "Timestamp" => Time.now.iso8601,
        "AWSAccessKeyId" => @options[:access_key]
      }
    end

    def to_query(hash)
      hash.sort.collect { |k, v| [encode(k), encode(v.to_s)].join("=") }.join("&")
    end

    def signed_query
      digest = HMAC::SHA256.digest(@options[:secret], request)
      signature = Base64.encode64(digest).chomp
      to_query(params.merge "Signature" => signature)
    end

    def encode(value)
      CGI.escape(value).gsub("%7E", "~").gsub("+", "%20")
    end

    def request
      "GET\nwebservices.amazon.com\n/onca/xml\n#{to_query(params)}"
    end

  end
  
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
