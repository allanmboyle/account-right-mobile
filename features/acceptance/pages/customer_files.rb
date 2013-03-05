module AccountRightMobile
  module Acceptance
    module Pages

      class CustomerFiles < Pages::Base

        def self.title
          "Customer Files"
        end

        def initialize(session, configuration)
          super(session, configuration)
        end

        def url
          "/#customer_files"
        end

        def access_a_file
          @session.find('#customer-files-list').all('a').first.click
        end

      end

    end
  end
end
