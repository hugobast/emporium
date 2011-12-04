module Emporium
  class Product
    attr_accessor :code
    
    def initialize(code, options={})
      @code = ::Code.new(code)
      raise "invalid code" unless @code.valid?
      @options = options.merge! code: @code.value
    end
    
    def fetch!
      if @service && @service == :amazon
        create ::Nokogiri::XML(open("http://webservices.amazon.com/onca/xml?#{signed_query}"))
      end
    end

    def use(service)
      @service = service
    end
    
  private

    def create(result)
      if @service == :amazon
        result.search("ItemAttributes").children.each do |value|
          self.instance_variable_set("@#{value.name.downcase}",  value.content)
          self.class.class_eval do
            define_method("#{value.name.downcase}") do
              value.content
            end
          end
        end
      end
    end
  
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
end
