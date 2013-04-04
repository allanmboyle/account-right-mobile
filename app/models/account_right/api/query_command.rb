module AccountRight
  module API

    class QueryCommand

      def initialize(resource_path, user_tokens)
        @request = AccountRight::API::Request.new(resource_path, user_tokens)
      end

      def submit
        HTTParty.get(@request.uri, headers: @request.headers)
      end

      def user_tokens
        @request.user_tokens
      end

      def to_s
        @request.to_s
      end

    end

  end
end
