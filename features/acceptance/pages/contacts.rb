module AccountRightMobile
  module Acceptance
    module Pages

      class Contacts < Pages::Base

        def self.name
          "Contacts"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/#contacts"
        end

      end

    end
  end
end
