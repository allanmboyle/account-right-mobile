module AccountRightMobile
  class LocalServer

    PID_DIR = "#{Rails.root}/tmp/pids"
    LOG_DIR = "#{Rails.root}/log"

    attr_writer :log

    def initialize(options)
      @name = options[:name]
      @port = options[:port]
      @log = AccountRightMobile::SimpleLog.new
      @deletable_artefacts = [pid_file_path]
    end

    def start!
      raise "#{@name} already running" if running?
      ensure_directories_exist
      pid = ::Process.spawn(start_command, { [:out, :err] => [log_file_path, "w"] })
      create_pid_file(pid)
      @log.info "#{@name} started"
    end

    def stop!
      raise "#{@name} not running" unless running?
      ::Process.kill_tree(9, current_pid)
      FileUtils.rm_f(@deletable_artefacts)
      @log.info "#{@name} stopped"
    end

    def status
      running? ? :started : :stopped
    end

    def to_s
      "#{@name} on port #{@port}"
    end

    private

    def running?
      !current_pid.nil?
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

    def delete_pid_file(pid)
      File.delete(pid_file_path)
    end

    def log_file_path
      File.join(LOG_DIR, "#{@name}_console.log")
    end

    def ensure_directories_exist
      FileUtils.mkdir_p([PID_DIR, LOG_DIR])
    end

  end
end
