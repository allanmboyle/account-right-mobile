module AccountRight

  class API

    class << self

      def invoke(resource_path, security_tokens)
        uri = "#{config["uri"]}/#{resource_path}"
        headers = headers_for(security_tokens)
        response = HTTParty.get(uri, headers: headers)
        Rails.logger.info("API:: URI: #{uri}\n    headers: #{headers}\n    response: #{response.code} #{response.body}")
        raise AccountRight::ApiError.new(response) unless response.code == 200
        response.body
      end

      private

      def headers_for(security_tokens)
        headers = { "Authorization" => "Bearer #{security_tokens[:access_token]}",
                    "x-myobapi-key" => config["key"],
                    "Accept-Encoding" => "gzip,deflate" }
        headers["x-myobapi-cftoken"] = security_tokens[:cf_token] if security_tokens[:cf_token]
        headers
      end

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end

end
