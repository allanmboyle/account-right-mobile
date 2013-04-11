module AccountRightMobile
  module Services
    module ApiStub

      module ContactConfigurer

        def self.included(mod)
          mod.extend(Initializer)
          mod.register_contact_stubs
        end

        module Initializer

          def register_contact_stubs
            stub_activator("/return_multiple_customers", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 200, body:
                               { "Items" => [ DataFactory.create_company(),
                                              DataFactory.create_individual(),
                                              DataFactory.create_company() ] }.to_json
                           })

            stub_activator("/return_multiple_suppliers", /#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                           method: :get,
                           response: { status: 200, body:
                               { "Items" => [ DataFactory.create_individual(),
                                              DataFactory.create_company(),
                                              DataFactory.create_individual() ] }.to_json
                           })

            stub_activator("/return_no_customers", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 200, body: { "Items" => [] }.to_json })

            stub_activator("/return_no_suppliers", /#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                           method: :get,
                           response: { status: 200, body: { "Items" => [] }.to_json })

            stub_activator("/return_customer_with_long_name", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 200, body:
                               { "Items" => [
                                   DataFactory.create_company(CoLastName: ::Faker::Lorem.characters(255))
                               ] }.to_json
                           })

            stub_activator("/return_customer_with_minimal_data", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 200, body:
                               { "Items" => [ DataFactory.create_contact_with_minimal_data() ]}.to_json
                           })

            stub_activator("/return_customers_error", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 500, body: "A general error occurred" })

            activate!("/return_multiple_customers")
            activate!("/return_multiple_suppliers")
          end

        end

        def return_contacts(contacts)
          stub_response!(/#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                         method: :get,
                         response: { status: 200, body: { "Items" => contacts[:customers] }.to_json })
          stub_response!(/#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                         method: :get,
                         response: { status: 200, body: { "Items" => contacts[:suppliers] }.to_json })
        end

        def return_no_contacts
          activate!("/return_no_customers")
          activate!("/return_no_suppliers")
        end

        def return_contacts_error
          activate!("/return_customers_error")
        end

      end

    end
  end
end
