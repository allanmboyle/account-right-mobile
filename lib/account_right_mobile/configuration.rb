module AccountRightMobile

  class Configuration
    
    DEFAULT_CONFIG_FILE = "#{Rails.root}/lib/account_right_mobile/config/defaults.yml"

    def self.load
      default_settings = YAML.load_file(DEFAULT_CONFIG_FILE)
      environment_settings = AccountRightMobileConfiguration::Configuration.load_for(Rails.env) rescue {}
      environment_settings.deeper_merge(default_settings)
    end

  end

end
