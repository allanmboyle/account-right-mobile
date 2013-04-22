module AccountRight
  module API

    class Error < AccountRight::API::Exception

      attr_reader :response_code

      def initialize(response)
        @response_code = response.code
        super("#{response.code} #{response.body}")
      end

    end

  end
end
