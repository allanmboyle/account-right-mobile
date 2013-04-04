module AccountRight
  module API

    class Request

      attr_reader :user_tokens

      def initialize(resource_path, user_tokens)
        @resource_path = resource_path
        @user_tokens = user_tokens
      end

      def uri
        "#{config["uri"]}/#{@resource_path}"
      end

      def headers
        headers = { "Authorization" => "Bearer #{@user_tokens[:access_token]}",
                    "x-myobapi-key" => config["key"],
                    "Accept-Encoding" => "gzip,deflate" }
        headers["x-myobapi-cftoken"] = @user_tokens[:cf_token] if @user_tokens[:cf_token]
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
