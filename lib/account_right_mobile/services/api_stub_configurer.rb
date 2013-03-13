module AccountRightMobile
  module Services

    class ApiStubConfigurer
      include ::HttpStub::Configurer

      COMPANY_FILE_URI = "/accountright"

      host "localhost"
      port 3003

      stub_activator("/return_many_files", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [ { "Name" => "Clearwater" },
                                                      { "Name" => "Muddywater" },
                                                      { "Name" => "Busyizzy" } ].to_json })

      stub_activator("/return_one_file", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [ { "Name" => "Clearwater" } ].to_json })

      stub_activator("/return_no_files", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 200, body: [].to_json })

      stub_activator("/return_error", COMPANY_FILE_URI,
                     method: :get,
                     response: { status: 500, body: "A general error occurred" })

      activate!("/return_many_files")

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
              headers: @headers,
              response: { status: 200, body: json })
      end

      def return_no_files
        activate!("/return_no_files")
      end

      def return_error
        activate!("/return_error")
      end

    end

  end
end
