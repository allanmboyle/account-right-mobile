module AccountRightMobile

  class Configuration
    
    DEFAULT_CONFIG_FILE = "#{Rails.root}/config/defaults.yml"

    def self.load
      default_settings = YAML.load_file(DEFAULT_CONFIG_FILE)
      environment_settings = AccountRightMobileConfiguration::Configuration.load_for(Rails.env) rescue {}
      default_settings.nested_merge(environment_settings)
    end

  end

end
