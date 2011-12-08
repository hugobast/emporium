require 'hmac'
require 'hmac-sha2'
require 'base64'
require 'nokogiri'

module Emporium
  module Services
    class Amazon
      include Emporium::Services::Options
      include Emporium::Services::Utilities

      service_attr_accessor :access_key, :secret, :associate_tag

      def initialize(options={})
        @options = options
      end

      def response
        attributes
      end

    private
      def attributes
        response = ::Nokogiri::XML(open("http://webservices.amazon.com/onca/xml?#{signed_query}"))
        message = response.search('Message')
        raise message.children.first.content unless message.empty?
        hash_from_xml response.search('ItemAttributes')
      end

      def signed_query
        digest = HMAC::SHA256.digest(@@secret, request)
        signature = Base64.encode64(digest).chomp
        query(params.merge "Signature" => signature)
      end

      def request
        "GET\nwebservices.amazon.com\n/onca/xml\n#{query(params)}"
      end

      def params
        {
          'Service'         => 'AWSECommerceService',
          'Operation'       => 'ItemLookup',
          'IdType'          => @options[:type]            || 'UPC',
          'ItemId'          => @options[:code],
          'SearchIndex'     => @options[:search_index]    || 'All',
          'ResponseGroup'   => @options[:response_group]  || 'Medium',
          'Version'         => @options[:version]         || '2011-08-01',
          'AssociateTag'    => @@associate_tag,
          'Timestamp'       => Time.now.iso8601,
          'AWSAccessKeyId'  => @@access_key
        }
      end
    end
  end
end