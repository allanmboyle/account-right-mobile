module AccountRight

  class CustomerFile

    def initialize(customer_file_id)
      @customer_file_id = customer_file_id
    end

    def accounting_properties(user_tokens)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/AccountingProperties", user_tokens)
    end

    def contacts(user_tokens)
      AccountRight::Contacts.new.concat(customers(user_tokens), "Customer")
                                .concat(suppliers(user_tokens), "Supplier")
    end

    private

    def customers(user_tokens)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/Customer", user_tokens)
    end

    def suppliers(user_tokens)
      AccountRight::API.invoke("accountright/#{@customer_file_id}/Supplier", user_tokens)
    end

  end
end
