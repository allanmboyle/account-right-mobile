module AccountRight
  module API

    class Query

      attr_reader :security_tokens

      def initialize(resource_path, security_tokens)
        @resource_path = resource_path
        @security_tokens = security_tokens
      end

      def uri
        "#{config["uri"]}/#{@resource_path}"
      end

      def headers
        headers = { "Authorization" => "Bearer #{@security_tokens[:access_token]}",
                    "x-myobapi-key" => config["key"],
                    "Accept-Encoding" => "gzip,deflate" }
        headers["x-myobapi-cftoken"] = @security_tokens[:cf_token] if @security_tokens[:cf_token]
        headers
      end

      private

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end
end
