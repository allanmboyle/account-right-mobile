module AccountRight

  class CustomerFile < Model::Base

    attr_accessor :id

    def initialize(attributes = {})
      super(attributes)
    end

    def accounting_properties(client_application_state)
      AccountRight::API.invoke("accountright/#{id}/AccountingProperties", client_application_state)
    end

    def contacts(client_application_state)
      AccountRight::Contacts.new.concat(customers(client_application_state), "Customer")
                                .concat(suppliers(client_application_state), "Supplier")
    end

    private

    def customers(client_application_state)
      AccountRight::API.invoke("accountright/#{id}/Customer", client_application_state)
    end

    def suppliers(client_application_state)
      AccountRight::API.invoke("accountright/#{id}/Supplier", client_application_state)
    end

  end
end
