class ContactsController < ApplicationController

  def index
    @contacts = [{ name: "A Customer", type: "Customer", balance: 100.00 },
                 { name: "A Supplier", type: "Supplier", balance: -100.00 },
                 { name: "G Customer", type: "Customer", balance: 200.00 },
                 { name: "W Customer", type: "Customer", balance: 150.00 }].map do |attributes|
      AccountRight::Contact.new(attributes)
    end
    respond_to do |format|
      format.json  { render :json => @contacts.to_json }
    end
  end

end
