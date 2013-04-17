module AccountRightMobile
  module Acceptance
    module Selenium

      module Cookies

        def get_cookie(name)
          driver.browser.manage.cookie_named(name)
        end

        def add_cookie(name)
          driver.browser.manage.add_cookie(name)
        end

      end

    end
  end
end
