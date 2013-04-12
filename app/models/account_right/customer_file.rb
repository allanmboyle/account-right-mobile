module AccountRight

  class CustomerFile < Model::Base

    attr_accessor :id, :name

    class << self

      def all(client_application_state)
        AccountRight::API.invoke("accountright", client_application_state)
      end

      def find(client_application_state)
        client_application_state.contains_customer_file? ? find_in_all_files(client_application_state) : "{}"
      end

      private

      def find_in_all_files(client_application_state)
        customer_files = JSON.parse(all(client_application_state))
        found_file = customer_files.find { |customer_file| customer_file["Id"] == client_application_state[:cf_id] }
        found_file ? found_file.to_json : "{}"
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
