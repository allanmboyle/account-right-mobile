module AccountRight

  class CustomerFile < Model::Base

    attr_accessor :id

    def self.all(client_application_state)
      AccountRight::API.invoke("accountright", client_application_state)
    end

    def initialize(attributes = {})
      super(attributes)
    end

    def accounting_properties(client_application_state)
      retrieve("AccountingProperties", client_application_state)
    end

    def contacts(client_application_state)
      AccountRight::Contacts.new.concat(retrieve("Customer", client_application_state), "Customer")
                                .concat(retrieve("Supplier", client_application_state), "Supplier")
    end

    private

    def retrieve(entity, client_application_state)
      AccountRight::API.invoke("accountright/#{id}/#{entity}", client_application_state)
    end

  end
end
