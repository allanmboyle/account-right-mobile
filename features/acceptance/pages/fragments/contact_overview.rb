module AccountRightMobile
  module Acceptance
    module Pages
      module Fragments

        class ContactOverview < ImmutableStruct.new(:name, :type, :balance)

          class << self

            def from_page_node(node)
              self.new(name: node.find(".name").text(),
                       type: node.find(".type").text(),
                       balance: node.find(".balance").text())
            end

            def from_api_model(model, type)
              name = "#{model[:CoLastName]}#{model[:IsIndividual] ? ", #{model[:FirstName]}" : ""}"
              balance_first_word = model[:CurrentBalance] < 0 ? "I" : "They"
              balance = "#{balance_first_word} owe #{sprintf("%.2f", model[:CurrentBalance].abs)}"
              self.new(name: name, type: type, balance: balance)
            end

          end

        end

      end
    end
  end
end
