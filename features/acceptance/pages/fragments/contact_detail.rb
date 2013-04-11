module AccountRightMobile
  module Acceptance
    module Pages
      module Fragments

        class ContactDetail < ImmutableStruct.new(:name, :type, :balance, :phone_numbers,
                                                  :email_address, :address)

          class << self

            def from_page_node(node)
              self.new(name: node.find(".name").text(),
                       type: node.find(".type").text(),
                       balance: node.find(".balance").text(),
                       phone_numbers: node.all(".phoneNumber").map { |nested_node| nested_node.text() },
                       email_address: node.find(".emailAddress").text(),
                       address: node.all(".address .line").map { |nested_node| nested_node.text() })
            end

            def from_api_model(model, type)
              overview = ContactOverview.from_api_model(model, type).to_h
              address = model[:Addresses].empty? ? {} : model[:Addresses][0]
              self.new(overview.merge(phone_numbers: address.values_at(:Phone1, :Phone2, :Phone3).compact,
                                      email_address: address[:Email],
                                      address: address.values_at(:Street, :City).compact <<
                                               address.values_at(:State, :PostCode, :Country).compact.join(" ")))
            end

          end

        end

      end
    end
  end
end
