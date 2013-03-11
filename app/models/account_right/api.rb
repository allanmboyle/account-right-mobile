module AccountRight

  class API

    class << self

      def customer_files(authorization_token)
        uri = "#{config["uri"]}/accountright"
        response = HTTParty.get(uri, headers: { "Authorization" => authorization_token,
                                                "x-myobapi-key" => config["key"],
                                                "Accept-Encoding" => "gzip,deflate" })
        response.body
      end

      private

      def config
        AccountRightMobile::Application.config.api
      end

    end

  end

end
