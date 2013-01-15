require "rails"

%w(action_controller action_mailer rails/test_unit sprockets).each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end
