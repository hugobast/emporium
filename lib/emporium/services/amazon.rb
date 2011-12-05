module Emporium
  module Services
    class Amazon
      def initialize(options={})
        @options = options
      end

      def response
        res = ::Nokogiri::XML(open("http://webservices.amazon.com/onca/xml?#{signed_query}"))
        message = res.search('Message')
        raise message.children.first.content unless message.empty?
        hash_from_xml(res.search('ItemAttributes'))
      end

    private

      def hash_from_xml(node)
        # Only the first level elements for now
        result_hash = {}
        node.children.each do |value|
          result_hash[value.name.downcase.to_sym] = value.content
        end
        result_hash
      end

      def params
        {
          "Service" => "AWSECommerceService",
          "Operation" => "ItemLookup",
          "IdType" => @options[:type] || "UPC",
          "ItemId" => @options[:code],
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
      class << self

        def configuration
          yield self
        end

        def class_option(*symbols)
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
      end

      class_option :access_key, :secret, :associate_tag
    end
  end
end