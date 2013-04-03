module AccountRight
  module API

    class QueryCommand

      def initialize(resource_path, security_tokens)
        @request = AccountRight::API::Request.new(resource_path, security_tokens)
      end

      def submit
        HTTParty.get(@request.uri, headers: @request.headers)
      end

      def security_tokens
        @request.security_tokens
      end

    end

  end
end
