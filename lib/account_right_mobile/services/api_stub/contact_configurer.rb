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
                               { "Items" => [
                                   { CoLastName: "hek scheen", FirstName: "", IsIndividual: false, CurrentBalance: 50000.00 },
                                   { CoLastName: "Clay", FirstName: "Bill", IsIndividual: true, CurrentBalance: 150.00 },
                                   { CoLastName: "Fenced-In", FirstName: "", IsIndividual: false, CurrentBalance: 2500.00 }
                               ]
                               }.to_json
                           })

            stub_activator("/return_multiple_suppliers", /#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                           method: :get,
                           response: { status: 200, body:
                               { "Items" => [
                                   { CoLastName: "Chan", FirstName: "Jackie", IsIndividual: true, CurrentBalance: -7000.00 },
                                   { CoLastName: "Power Source", FirstName: "", IsIndividual: false, CurrentBalance: -10000.00 },
                                   { CoLastName: "Heed", FirstName: "Trent", IsIndividual: false, CurrentBalance: -800.00 }
                               ]
                               }.to_json
                           })

            stub_activator("/return_no_customers", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 200, body: { "Items" => [] }.to_json })

            stub_activator("/return_no_suppliers", /#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                           method: :get,
                           response: { status: 200, body: { "Items" => [] }.to_json })

            stub_activator("/return_customers_error", /#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                           method: :get,
                           response: { status: 500, body: "A general error occurred" })

            activate!("/return_multiple_customers")
            activate!("/return_multiple_suppliers")
          end

        end

        def return_customers(customers)
          stub_response!(/#{COMPANY_FILE_URI}\/[^\/]+\/Customer/,
                         method: :get,
                         response: { status: 200, body: { "Items" => customers }.to_json })
        end

        def return_suppliers(suppliers)
          stub_response!(/#{COMPANY_FILE_URI}\/[^\/]+\/Supplier/,
                         method: :get,
                         response: { status: 200, body: { "Items" => suppliers }.to_json })
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
