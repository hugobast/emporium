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
        return JSON.parse("{ \"some\": \"json\" }")
      end

    private
      

      def params

      end

      def query
        
      end

      def request
        "https://www.googleapis.com/shopping/search/v1/public/products?#{query}"
      end
    end
  end
end