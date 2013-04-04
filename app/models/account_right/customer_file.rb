module AccountRight

  class CustomerFile

    def initialize(customer_file_id)
      @customer_file_id = customer_file_id
    end

    def accounting_properties(client_application_state)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/AccountingProperties", client_application_state)
    end

    def contacts(client_application_state)
      AccountRight::Contacts.new.concat(customers(client_application_state), "Customer")
                                .concat(suppliers(client_application_state), "Supplier")
    end

    private

    def customers(client_application_state)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/Customer", client_application_state)
    end

    def suppliers(client_application_state)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/Supplier", client_application_state)
    end

  end
end
