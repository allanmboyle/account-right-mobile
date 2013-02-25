module AccountRightMobile
  module Services

    class RailsServer < AccountRightMobile::Services::LocalServer

      DEFAULT_PID_FILE_PATH = "#{PID_DIR}/server.pid"

      def initialize(options)
        super(options.merge(name: "rails_#{options[:environment]}_server"))
        @environment = options[:environment]
      end

      def start_command
        "rails s -e #{@environment} -p #{@port}"
      end

      def pid_file_path
        DEFAULT_PID_FILE_PATH
      end

      def create_pid_file(pid)
        # Intentionally blank as Rails creates pid file
      end

    end

  end
end
