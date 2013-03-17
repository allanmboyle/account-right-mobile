shared_context "server lifecycle utilities" do

  let(:log) { AccountRightMobile::Services::SilentLog.new }
  let(:pid_file_path) { "#{Rails.root}/tmp/pids/#{pid_file_name}"}
  let(:pid_file_backup_directory) { "#{Rails.root}/tmp/backup/pids" }
  let(:pid_file_backup_path) { "#{pid_file_backup_directory}/#{pid_file_name}"}

  before(:all) { ensure_pid_file_backup_directory_exists! }

  before(:each) { log.stub!(:info) }

  def force_start!
    server.start!
    wait_until_started!
  end

  alias_method :force_server_start!, :force_start!

  def force_stop!
    server.stop!
    wait_until_stopped!
  end

  alias_method :force_server_stop!, :force_stop!

  def force_pid_file_creation!
    File.open(pid_file_path, "w") { |file| file.write "0" }
    wait_until_file_exists!(pid_file_path)
  end

  def force_pid_file_deletion!
    FileUtils.rm_f(pid_file_path)
    AccountRightMobile::Wait.until_true!("#{pid_file_path} is deleted") { !pid_file_exists? }
  end

  def restore_pid_file!
    FileUtils.cp(pid_file_backup_path, pid_file_path)
    wait_until_file_exists!(pid_file_path)
  end

  def wait_until_started!
    AccountRightMobile::Wait.until_true!("#{description} starts") do
      !!Net::HTTP.get_response("localhost", "/", port) && pid_file_exists?
    end
    FileUtils.cp(pid_file_path, pid_file_backup_path)
  end

  def wait_until_stopped!
    AccountRightMobile::Wait.until_true!("#{description} stops") do
      begin
        Net::HTTP.get_response("localhost", "/", port)
        false
      rescue
        !pid_file_exists?
      end
    end
  end

  def wait_until_file_exists!(file)
    AccountRightMobile::Wait.until_true!("#{file} exists") { File.exists?(file) }
  end

  def ensure_pid_file_backup_directory_exists!
    FileUtils.mkdir_p(pid_file_backup_directory)
    wait_until_file_exists!(pid_file_backup_directory)
  end

  def pid_file_exists?
    File.exists?(pid_file_path)
  end

end
