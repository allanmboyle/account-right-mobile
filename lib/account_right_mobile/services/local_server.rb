module AccountRightMobile
  module Services

    class LocalServer

      PID_DIR = "#{Rails.root}/tmp/pids"
      LOG_DIR = "#{Rails.root}/log"

      def initialize(options)
        @name = options[:name]
        @port = options[:port]
        @log = options[:log] || AccountRightMobile::Services::StdOutLog.new
        @deletable_artefacts = [pid_file_path]
      end

      def start!
        if running?
          @log.info "#{@name} already running on port #{@port}"
        else
          ensure_directories_exist
          pid = ::Process.spawn(start_command, { [:out, :err] => [log_file_path, "w"] })
          create_pid_file(pid)
          ::Wait.until_true!("#{@name} is running") { running? }
          @log.info "#{@name} started on port #{@port}"
        end
      end

      def stop!
        if running?
          ::Process.kill_tree(9, current_pid)
          FileUtils.rm_f(@deletable_artefacts)
          @log.info "#{@name} stopped"
        else
          @log.info "#{@name} not running"
        end
      end

      def status
        running? ? :started : :stopped
      end

      def to_s
        "#{@name} on port #{@port}"
      end

      private

      def running?
        !!Net::HTTP.get_response("localhost", "/", @port) rescue false
      end

      def current_pid
        File.exists?(pid_file_path) ? File.read(pid_file_path).to_i : nil
      end

      def pid_file_path
        File.join(PID_DIR, "#{@name}.pid")
      end

      def create_pid_file(pid)
        File.open(pid_file_path, "w") { |file| file.write(pid) }
      end

      def log_file_path
        File.join(LOG_DIR, "#{@name}_console.log")
      end

      def ensure_directories_exist
        FileUtils.mkdir_p([PID_DIR, LOG_DIR])
      end

    end

  end
end
