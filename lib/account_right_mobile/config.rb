module AccountRightMobile

  class Config
    
    class << self

      BASE_DIR = "#{Rails.root}/lib/account_right_mobile/config"
      DEFAULT_PATH = "#{BASE_DIR}/public/defaults.yml"

      def load
        environment_config_dir = Rails.env == "production" ? "private" : "public"
        default_settings = load_file(DEFAULT_PATH)
        environment_settings = load_file("#{BASE_DIR}/#{environment_config_dir}/#{Rails.env}.yml")
        environment_settings.deeper_merge(default_settings)
      end

      private

      def load_file(file)
        File.exists?(file) ? YAML.load_file(file) || {} : {}
      end

    end

  end

end
