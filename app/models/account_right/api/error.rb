module AccountRight
  module API

    class Error < Exception

      attr_reader :response_code

      def initialize(response)
        @response_code = response.code
        super(response.body)
      end

    end

  end
end
