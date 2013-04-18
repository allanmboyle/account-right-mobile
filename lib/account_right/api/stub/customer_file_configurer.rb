module AccountRight
  module API
    module Stub

      module CustomerFileConfigurer

        def self.included(mod)
          mod.extend(Initializer)
          mod.register_customer_file_stubs
        end

        module Initializer

          def register_customer_file_stubs
            stub_activator("/return_many_files", COMPANY_FILE_URI,
                           method: :get,
                           headers: NORMAL_HEADERS,
                           response: { status: 200,
                                       body: [ DataFactory.create_customer_file(),
                                               DataFactory.create_customer_file(),
                                               DataFactory.create_customer_file() ].to_json })

            stub_activator("/return_one_file", COMPANY_FILE_URI,
                           method: :get,
                           headers: NORMAL_HEADERS,
                           response: { status: 200, body: [ DataFactory.create_customer_file() ].to_json })

            stub_activator("/return_file_with_long_name", COMPANY_FILE_URI,
                           method: :get,
                           headers: NORMAL_HEADERS,
                           response: { status: 200, body: [
                               DataFactory.create_customer_file(Name: "A Customer File with an extremely long name that should extend past the width of a phone")
                           ].to_json })

            stub_activator("/return_no_files", COMPANY_FILE_URI,
                           method: :get,
                           headers: NORMAL_HEADERS,
                           response: { status: 200, body: [].to_json })

            stub_activator("/grant_access", /#{COMPANY_FILE_URI}\/[^\/]+\/AccountingProperties/,
                           method: :get,
                           headers: NORMAL_HEADERS,
                           response: { status: 200, body: [].to_json })

            stub_activator("/deny_access", /#{COMPANY_FILE_URI}\/[^\/]+\/AccountingProperties/,
                           method: :get,
                           response: { status: 401, body: [].to_json })

            activate!("/return_many_files")
            activate!("/grant_access")
          end

        end

        def return_many_files
          activate!("/return_many_files")
        end

        def return_one_file
          activate!("/return_one_file")
        end

        def return_files(customer_files)
          stub!(COMPANY_FILE_URI, method: :get, response: { status: 200, body: customer_files.to_json })
        end

        def return_no_files
          activate!("/return_no_files")
        end

        def grant_access
          stub!(/#{COMPANY_FILE_URI}\/[^\/]+\/AccountingProperties/,
                method: :get, response: { status: 200, body: [].to_json })
        end

        def deny_access
          stub!(/#{COMPANY_FILE_URI}\/[^\/]+\/AccountingProperties/,
                method: :get, response: { status: 401, body: [].to_json })
        end

      end

    end
  end
end
