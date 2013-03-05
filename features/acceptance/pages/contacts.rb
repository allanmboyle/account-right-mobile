module AccountRightMobile
  module Acceptance
    module Pages

      class Contacts < Pages::Base

        def self.name
          "Contacts"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#contacts"
        end

      end

    end
  end
end
