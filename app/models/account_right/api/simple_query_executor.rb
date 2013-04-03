module AccountRight
  module API

    class SimpleQueryExecutor

      def self.execute(query)
        response = HTTParty.get(query.uri, headers: query.headers)
        Rails.logger.info("API:: URI: #{query.uri}\n    headers: #{query.headers}\n    response: #{response.code} #{response.body}")
        raise AccountRight::API::Error.new(response) unless response.code == 200
        response.body
      end

    end

  end
end
