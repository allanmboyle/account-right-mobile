module AccountRightMobile
  class Node

    def self.installed!
      begin
        execute_with_logging("node -v")
      rescue
        raise "Node.js must be installed"
      end
    end

  end
end
