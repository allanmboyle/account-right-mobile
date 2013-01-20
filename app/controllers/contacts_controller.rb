class ContactsController < ApplicationController

  def index
    @contacts = [Contact.new(name: "A Customer", type: "Customer", balance: 100.00),
                 Contact.new(name: "A Supplier", type: "Customer", balance: -100.00),
                 Contact.new(name: "G Customer", type: "Supplier", balance: 200.00),
                 Contact.new(name: "W Customer", type: "Customer", balance: 150.00)]
    respond_to do |format|
      format.json  { render :json => @contacts.to_json }
    end
  end

end
