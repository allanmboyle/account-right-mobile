module AccountRight
  module API

    class ErrorFactory
      extend RSpec::Mocks::ExampleMethods

      def self.create(code=500)
        AccountRight::API::Error.new(double("HttpResponse", code: code, body: "some body"))
      end

    end

  end
end
