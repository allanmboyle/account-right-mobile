module AccountRight
  module API

    class DataFactory

      class << self

        def create_customer_file(options={})
          { Id: AccountRight::API::Faker::CustomerFile.id, Name: ::Faker::Company.name }.merge(options)
        end

        def create_company(options={})
          create_contact({ CoLastName: ::Faker::Company.name, FirstName: "", IsIndividual: false }.merge(options))
        end

        def create_individual(options={})
          create_contact({ CoLastName: ::Faker::Name.last_name, FirstName: ::Faker::Name.first_name,
                           IsIndividual: true }.merge(options))
        end

        def create_contact_with_minimal_data
          { CoLastName: ::Faker::Company.name, FirstName: "", IsIndividual: false,
            CurrentBalance: ::Extensions::Faker::Money.random, Addresses: [] }
        end

        private

        def create_contact(options)
          { CurrentBalance: ::Extensions::Faker::Money.random,
            Addresses: [ { Index: 1, Phone1: ::Faker::PhoneNumber.phone_number,
                           Phone2: ::Faker::PhoneNumber.cell_phone, Phone3: ::Faker::PhoneNumber.phone_number,
                           Email: ::Faker::Internet.email, Street: ::Faker::Address.street_address,
                           City: ::Faker::Address.city, State: ::Faker::Address.state_abbr,
                           PostCode: ::Faker::Address.postcode, Country: "Australia" } ] }.merge(options)
        end

      end

    end

  end
end
