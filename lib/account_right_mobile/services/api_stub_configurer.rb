module AccountRightMobile
  module Services

    class ApiStubConfigurer
      include ::HttpStub::Configurer

      COMPANY_FILE_URI = "/accountright"

      host "localhost"
      port 3003

      stub_activator("/return_many_files", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [ { "Name" => "Clearwater",
                                                        "Id" => "13dc8751-7431-4b55-bc72-01b5fc2a07f0" },
                                                      { "Name" => "Muddywater",
                                                        "Id" => "23dc8751-7431-4b55-bc72-01b5fc2a07f0" },
                                                      { "Name" => "Busyizzy",
                                                        "Id" => "33dc8751-7431-4b55-bc72-01b5fc2a07f0" } ].to_json })

      stub_activator("/return_one_file", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [ { "Name" => "Clearwater" } ].to_json })

      stub_activator("/return_no_files", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [].to_json })

      stub_activator("/return_error", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 500, body: "A general error occurred" })

      stub_activator("/grant_all_file_access", /#{COMPANY_FILE_URI}\/[^\/]+\/AccountingProperties/,
                     method: :get,
                     response: { status: 200, body: [].to_json })

      activate!("/return_many_files")
      activate!("/grant_all_file_access")

      def initialize(headers={})
        @headers = headers
      end

      def self.with(headers)
        ApiStubConfigurer.new(headers)
      end

      def return_many_files
        activate!("/return_many_files")
      end

      def return_one_file
        activate!("/return_one_file")
      end

      def return_files(file_names)
        json = file_names.map { |name| { "Name" => name } }.to_json
        stub!(COMPANY_FILE_URI,
              method: :get,
              response: { status: 200, body: json })
      end

      def return_no_files
        activate!("/return_no_files")
      end

      def return_error
        activate!("/return_error")
      end

      alias_method :stub_without_headers!, :stub!

      def stub!(uri, options)
        stub_without_headers!(uri, options.merge(headers: @headers))
      end

      alias_method :stub_response!, :stub!

    end

  end
end
