Capybara::Session.send(:include, AccountRightMobile::Acceptance::Selenium::Navigation)
Capybara::Session.send(:include, AccountRightMobile::Acceptance::Selenium::Cookies)

configuration = AccountRightMobile::Application.config.test

Capybara.run_server = false
Capybara.app_host = configuration["app_uri"]

Capybara.register_driver(:selenium_override) do |app|
  type = (ENV["driver"] &&  ENV["driver"].to_sym) || :iphone_firefox
  AccountRightMobile::Acceptance::Selenium::Drivers::DriverFactory.create(type: type, app: app)
end

Capybara.default_wait_time = ::Wait.default_timeout_in_seconds = configuration["timeout_in_seconds"]
Capybara.default_driver = :selenium_override #Defaults to :rack_test
Capybara.javascript_driver = :selenium_override #Defaults to :selenium

Before do
  @session = Capybara.current_session
end
