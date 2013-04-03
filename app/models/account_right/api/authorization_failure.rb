module AccountRight
  module API

    class AuthorizationFailure < Exception

      def initialize(response)
        super(response.body)
      end

    end

  end
end
