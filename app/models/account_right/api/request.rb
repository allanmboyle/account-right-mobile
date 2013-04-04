module AccountRight
  module API

    class Request

      attr_reader :client_application_state

      def initialize(resource_path, client_application_state)
        @resource_path = resource_path
        @client_application_state = client_application_state
      end

      def uri
        "#{config["uri"]}/#{@resource_path}"
      end

      def headers
        headers = { "Authorization" => "Bearer #{@client_application_state[:access_token]}",
                    "x-myobapi-key" => config["key"],
                    "Accept-Encoding" => "gzip,deflate" }
        headers["x-myobapi-cftoken"] = @client_application_state[:cf_token] if @client_application_state[:cf_token]
        headers
      end

      def to_s
        "URI: #{uri}\n\tHeaders: #{headers}"
      end

      private

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end
end
