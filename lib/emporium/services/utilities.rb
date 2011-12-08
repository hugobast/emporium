module Emporium
  module Services
    module Utilities
      def hash_from_xml(xml)
        # Only the first level elements for now

        result_hash = {}
        xml.children.each do |value|
          result_hash[value.name.downcase.to_sym] = value.content
        end
        result_hash
      end

      def hash_from_json(json)
      end

      def query(hash)
        hash.sort.collect { 
          |k, v| [encode(k), encode(v.to_s)].join("=") 
        }.join("&")
      end

      def encode(value)
        CGI.escape(value)
      end
    end
  end
end