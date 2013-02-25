require File.expand_path('../../../lib/account_right_mobile/config', __FILE__)

settings = AccountRightMobile::Config.load
settings.each { |key, value| AccountRightMobile::Application.config.send("#{key}=".to_sym, value) }
