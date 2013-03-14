module AccountRight

  class API

    class << self

      def invoke(resource_path, authorization_token)
        uri = "#{config["uri"]}/#{resource_path}"
        response = HTTParty.get(uri, headers: { "Authorization" => authorization_token,
                                                "Accept-Encoding" => "gzip,deflate",
                                                "x-myobapi-key" => config["key"] })
        response.body
      end

      private

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end

end
