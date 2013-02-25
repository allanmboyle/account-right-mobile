module AccountRightMobile

  class Config
    
    class << self

      BASE_DIR = "#{Rails.root}/lib/account_right_mobile/config"
      DEFAULT_PATH = "#{BASE_DIR}/public/defaults.yml"

      def load
        environment_config_dir = Rails.env == "production" ? "private" : "public"
        default_settings = YAML.load_file(DEFAULT_PATH) || {}
        environment_settings = YAML.load_file("#{BASE_DIR}/#{environment_config_dir}/#{Rails.env}.yml") || {}
        environment_settings.deeper_merge(default_settings)
      end

      def merge_into_rails_config!
        settings = self.load
        settings.each { |key, value| AccountRightMobile::Application.config.send("#{key}=".to_sym, value) }
      end
      
    end

  end

end
