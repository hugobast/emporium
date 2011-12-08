require 'json'

module Emporium
  module Services
    class Google
      def initialize(options={})
        @options = options
      end

      def response
        return JSON.parse("{ \"some\": \"json\" }")
      end
    end
  end
end