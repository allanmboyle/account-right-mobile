module AccountRight
  module API

    class QueryCommand

      def initialize(resource_path, client_application_state)
        @request = AccountRight::API::Request.new(resource_path, client_application_state)
      end

      def submit
        HTTParty.get(@request.uri, headers: @request.headers)
      end

      def client_application_state
        @request.client_application_state
      end

      def to_s
        @request.to_s
      end

    end

  end
end
