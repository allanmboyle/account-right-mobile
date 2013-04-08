module AccountRightMobile
  module Services
    module ApiStub

      class Configurer
        include ::HttpStub::Configurer

        host "localhost"
        port 3003

        include AccountRightMobile::Services::ApiStub::CustomerFileConfigurer
        include AccountRightMobile::Services::ApiStub::ContactConfigurer

        stub_activator("/return_errors", /#{COMPANY_FILE_URI}.*/,
                       method: :get,
                       response: { status: 500, body: "A general error occurred" })

        def initialize
          @headers = {}
        end

        def with_headers(headers)
          @headers = headers
          self
        end

        def return_errors
          activate!("/return_errors")
        end

        alias_method :stub_without_headers!, :stub!

        def stub!(uri, options)
          stub_without_headers!(uri, { headers: @headers }.merge(options))
        end

        alias_method :stub_response!, :stub!

      end

    end
  end
end
