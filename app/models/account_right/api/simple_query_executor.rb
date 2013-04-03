module AccountRight
  module API

    class SimpleQueryExecutor

      def self.execute(query)
        response = query.submit
        Rails.logger.info("API:: #{query}\n    response: #{response.code} #{response.body}")
        raise AccountRight::API::AuthorizationFailure.new(response) if response.code == 401
        raise AccountRight::API::Error.new(response) unless response.code == 200
        response.body
      end

    end

  end
end
