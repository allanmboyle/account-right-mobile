require File.expand_path('../../../lib/account_right_mobile/configuration', __FILE__)

settings = AccountRightMobile::Configuration.load
settings.each { |key, value| AccountRightMobile::Application.config.send("#{key}=".to_sym, value) }
