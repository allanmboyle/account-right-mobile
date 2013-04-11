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
                       phone_numbers: text_from(node.all(".phoneNumber")),
                       email_address: text_from(node.first(".emailAddress")),
                       address: text_from(node.all(".address .line")))
            end

            def from_api_model(model, type)
              overview = ContactOverview.from_api_model(model, type).to_h
              address = model[:Addresses].empty? ? {} : model[:Addresses][0]
              self.new(overview.merge(phone_numbers: address.values_at(:Phone1, :Phone2, :Phone3).compact,
                                      email_address: address[:Email],
                                      address: address.values_at(:Street, :City).compact <<
                                               address.values_at(:State, :PostCode, :Country).compact.join(" ")))
            end

            private

            def text_from(node_or_nodes)
              node_or_nodes.is_a?(Enumerable) ? text_from_nodes(node_or_nodes) : text_from_node(node_or_nodes)
            end

            def text_from_nodes(nodes)
              nodes.map { |node| node.text() }
            end

            def text_from_node(node)
              node ? node.text() : ""
            end

          end

        end

      end
    end
  end
end
