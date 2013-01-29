Capybara.run_server = false
Capybara.app_host = "http://localhost:3000"

Capybara.register_driver(:selenium_override) do |app|
  AccountRightMobile::Acceptance::DriverFactory.for(app).create(ENV['driver'] || :firefox)
end

Capybara.default_driver = :selenium_override #Defaults to :rack_test
Capybara.javascript_driver = :selenium_override #Defaults to :selenium
