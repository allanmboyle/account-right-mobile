module AccountRight

  class API

    class << self

      def invoke(resource_path, authorization_token, cftoken=nil)
        uri = "#{config["uri"]}/#{resource_path}"
        response = HTTParty.get(uri, headers: headers_for(authorization_token, cftoken))
        Rails.logger.info("API:: #{uri} response: #{response.code} #{response.body}")
        raise AccountRight::ApiError.new(response) unless response.code == 200
        response.body
      end

      private

      def headers_for(authorization_token, cftoken)
        result = { "Authorization" => "Bearer #{authorization_token}",
                   "x-myobapi-key" => config["key"],
                   "Accept-Encoding" => "gzip,deflate" }
        result["x-myobapi-cftoken"] = cftoken if cftoken
        result
      end

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end

end
