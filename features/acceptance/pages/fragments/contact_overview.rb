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
              self.new(name: name, type: type, balance: balance_from_api_model(model))
            end

            private

            def balance_from_api_model(model)
              first_word = if model[:CurrentBalance] < 0
                "I"
              elsif model[:CurrentBalance] > 0
                "They"
              end
              starting_phrase = first_word ? "#{first_word} owe " : ""
              "#{starting_phrase}#{sprintf("%.2f", model[:CurrentBalance].abs)}"
            end

          end

        end

      end
    end
  end
end
