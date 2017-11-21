module Rapa
  module Responses
    class LookupInBrowseNodeResponse < BaseResponse
      # @return [Rapa::Error, nil]
      def error
        if value = body.dig("BrowseNodeLookupErrorResponse", "Error")
          ::Rapa::Error.new(value)
        end
      end

      # @return [Boolean]
      def has_error?
        !error.nil?
      end

      # @return [Boolean]
      def has_valid_request?
        body.dig("BrowseNodeLookupResponse", "BrowseNodes", "Request", "IsValid") == "True"
      end

      private

      # @note Override
      def resource_class
        ::Rapa::Resources::ItemResource
      end

      # @note Override
      def source_or_sources
        body.dig("BrowseNodeLookupResponse", "BrowseNodes", "BrowseNode", "TopItemSet", "TopItem")
      end
    end
  end
end