module AccountRightMobile
  class RailsServer < AccountRightMobile::LocalServer

    DEFAULT_PID_FILE_PATH = "#{PID_DIR}/server.pid"

    def initialize(options)
      super(options.merge(name: "rails_#{options[:environment]}_server"))
      @environment = options[:environment]
      @deletable_artefacts << DEFAULT_PID_FILE_PATH
    end

    def start_command
      "rails s -e #{@environment} -p #{@port}"
    end

  end
end
