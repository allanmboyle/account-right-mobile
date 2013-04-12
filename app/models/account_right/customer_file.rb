module AccountRight

  class CustomerFile < Model::Base

    attr_accessor :id, :name

    class << self

      def all(client_application_state)
        AccountRight::API.invoke("accountright", client_application_state)
      end

      def find(client_application_state)
        customer_files = JSON.parse(self.all(client_application_state))
        customer_file = customer_files.find { |customer_file| customer_file["Id"] == client_application_state[:cf_id] }
        customer_file ? customer_file.to_json : ""
      end

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
