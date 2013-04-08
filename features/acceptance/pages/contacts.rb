module AccountRightMobile
  module Acceptance
    module Pages

      class Contacts < Pages::Base

        def self.title
          "Contacts"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contacts"
        end

        def contacts
          @session.all(".contact").map do |node|
            { name: node.find(".name").text(), type: node.find(".type").text(), balance: node.find(".balance").text() }
          end
        end

      end

    end
  end
end
