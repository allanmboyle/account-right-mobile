module AccountRightMobile
  module Acceptance
    module Pages
      module Fragments

        class ContactOverview < ImmutableStruct.new(:name, :type, :balance)

          class << self
            include ActionView::Helpers::NumberHelper

            def from_page_node(node)
              self.new(name: node.find(".name").text(),
                       type: node.find(".type").text(),
                       balance: balance_from_node(node.find(".balance")))
            end

            def from_api_model(model, type)
              name = "#{model[:CoLastName]}#{model[:IsIndividual] ? ", #{model[:FirstName]}" : ""}"
              self.new(name: name, type: type, balance: number_to_currency(model[:CurrentBalance]))
            end

            private

            def balance_from_node(node)
              balance = node.text().match(/\$.*/)[0]
              node.text().starts_with?("I") ? "-#{balance}" : balance
            end

          end

        end

      end
    end
  end
end
