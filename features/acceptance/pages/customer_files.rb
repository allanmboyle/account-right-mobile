module AccountRightMobile
  module Acceptance
    module Pages

      class CustomerFiles < Pages::Base

        def self.name
          "Customer Files"
        end

        def initialize(session)
          super(session)
        end

        def url
          "/customer_files"
        end

        def shown?
          @session.has_content?(self.class.name)
        end

      end

    end
  end
end
