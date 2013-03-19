module AccountRightMobile
  module Acceptance
    module DSL

      def find_page(page_name)
        page_class = AccountRightMobile::Acceptance::Pages::Base.page_class_with_title(page_name)
        page_class.new(Capybara.current_session, configuration)
      end

      def configuration
        AccountRightMobile::Application.config.test
      end

    end
  end
end
