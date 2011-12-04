module Emporium
  class Product
    attr_accessor :code
    
    def initialize(code, options={})
      @code = ::Code.new(code)
      raise "invalid code" unless @code.valid?
      @options = options.merge! code: @code.value
    end
    
    def fetch!
      if @@service == :amazon
        create ::Nokogiri::XML(open("#{@@service_url}?#{signed_query}"))
      end
    end

    def self.class_option(*symbols)
      symbols.each do |symbol|
        class_eval(<<-EOS)
          def self.#{symbol}
            @@#{symbol}
          end

          def self.#{symbol}=(value)
            @@#{symbol} = value
          end
        EOS
      end
    end

    class_option :access_key, :secret, :associate_tag
    class_option :service, :service_url

    def method_missing(name, *args)
      if self.instance_variables.include? :"@#{name}"
        self.instance_variable_get("@#{name}")
      else
        super
      end
    end
    
  private

    def create(result)
      if @@service == :amazon
        result.search("ItemAttributes").children.each do |value|
          self.instance_variable_set("@#{value.name.downcase}",  value.content)
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
        "AssociateTag" => @@associate_tag,
        "Timestamp" => Time.now.iso8601,
        "AWSAccessKeyId" => @@access_key
      }
    end

    def to_query(hash)
      hash.sort.collect { |k, v| [encode(k), encode(v.to_s)].join("=") }.join("&")
    end

    def signed_query
      digest = HMAC::SHA256.digest(@@secret, request)
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
