Capybara.run_server = false
Capybara.app_host = ENV["app_host"]

Capybara.register_driver(:selenium_override) do |app|
  type = (ENV["driver"] &&  ENV["driver"].to_sym) || :firefox
  AccountRightMobile::Acceptance::Drivers::DriverFactory.create(type: type, app: app)
end

Capybara.default_wait_time = 5 # seconds
Capybara.default_driver = :selenium_override #Defaults to :rack_test
Capybara.javascript_driver = :selenium_override #Defaults to :selenium
