require "cgi"
require "time"

module Rapa
  module Queries
    class BaseQuery
      SERVICE = "AWSECommerceService"
      VERSION = "2013-08-01"

      class << self
        attr_writer :property_names

        # @note Override
        def inherited(child_class)
          child_class.property_names = property_names.clone
        end

        # @return [Array<Symbol>]
        def property_names
          @property_names ||= []
        end

        # @param property_name [Symbol]
        def property(property_name)
          property_names << property_name
        end
      end

      property :AssociateTag
      property :AWSAccessKeyId
      property :Operation
      property :RelatedItemPage
      property :RelationshipType
      property :ResponseGroup
      property :Service
      property :Timestamp
      property :Version

      # @param options [Hash]
      def initialize(options = {})
        @options = options
      end

      # @return [String]
      def AssociateTag
        options[:associate_tag]
      end

      # @return [String]
      def AWSAccessKeyId
        options[:access_key_id]
      end

      # @return [String]
      def Operation
        raise ::NotImplementedError
      end

      # @return [Integer, nil]
      def RelatedItemPage
        options[:related_item_page]
      end

      # @return [String, nil]
      def RelationshipType
        options[:relationship_type]
      end

      # @return [String, nil]
      def ResponseGroup
        if options[:response_groups]
          options[:response_groups].join(",")
        end
      end

      # @return [String]
      def Service
        SERVICE
      end

      # @return [String]
      def Timestamp
        ::Time.now.utc.iso8601
      end

      # @return [Hash]
      def to_hash
        self.class.property_names.each_with_object({}) do |property_name, result|
          value = send(property_name)
          unless value.nil?
            result[property_name.to_s] = ::CGI.escape(value).gsub(" ", "%20")
          end
        end.sort.to_h
      end

      # @return [String]
      def to_s
        to_hash.map do |key, value|
          [
            key,
            value,
          ].join("=")
        end.join("&")
      end

      # @return [String]
      def Version
        VERSION
      end

      private

      # @private
      # @return [Hash]
      def options
        @options
      end
    end
  end
end
