module AccountRight

  class API

    class << self

      def invoke(resource_path, access_token, cftoken=nil)
        uri = "#{config["uri"]}/#{resource_path}"
        headers = headers_for(access_token, cftoken)
        response = HTTParty.get(uri, headers: headers)
        Rails.logger.info("API:: URI: #{uri}\n    headers: #{headers}\n    response: #{response.code} #{response.body}")
        raise AccountRight::ApiError.new(response) unless response.code == 200
        response.body
      end

      private

      def headers_for(access_token, cftoken)
        result = { "Authorization" => "Bearer #{access_token}",
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
