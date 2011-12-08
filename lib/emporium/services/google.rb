require 'json'

module Emporium
  module Services
    class Google
      include Emporium::Services::Options
      service_attr_accessor :access_key, :cse

      def initialize(options={})
        @options = options
      end

      def response
        attributes
      end

    private
      include Emporium::Services::Utilities

      def attributes
        response = open(request)
        hash = hash_from_json(response.read)
        raise message unless hash["totalItems"] > 0
        hash["items"][0]["product"]
      end

      def message
        "q=#{@options[:code]} generated no results"
      end

      def request
        "https://www.googleapis.com/shopping/search/v1/public/products?#{query(params)}"
      end

      def params
        {
          'q'       => @options[:code],
          'alt'     => @options[:alt]     || 'json',
          'country' => @options[:country] || 'US',
          'key'     => @@access_key
        }
      end
    end
  end
end