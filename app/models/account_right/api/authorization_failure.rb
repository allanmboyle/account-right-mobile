module AccountRight
  module API

    class AuthorizationFailure < AccountRight::API::Exception

      def initialize(response)
        super(response.body)
      end

    end

  end
end
