module AccountRight
  module API

    class SimpleCommandProcessor

      def self.execute(command)
        response = command.submit
        Rails.logger.info("API:: #{command}\n\tResponse: #{response.code} #{response.body}")
        raise AccountRight::API::AuthorizationFailure.new(response) if response.code == 401
        raise AccountRight::API::Error.new(response) unless response.code == 200
        response.body
      end

    end

  end
end
