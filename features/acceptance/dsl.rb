module AccountRightMobile
  module Acceptance
    module DSL

      def find_page(page_name)
        page_class = AccountRightMobile::Acceptance::Pages::Base.page_class_with_name(page_name)
        page_class.new(Capybara.current_session)
      end

    end
  end
end