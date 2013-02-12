module AccountRightMobile
  class Npm

    class << self

      def install_if_possible
        execute_with_logging("npm install") if installed?
      end

      def root
        Rails.root.join("node_modules")
      end

      private

      def installed?
        @installed ||= begin
          execute_with_logging("npm -v")
          puts "npm detected"
          true
        rescue
          puts "npm not detected"
          false
        end
      end

    end

  end
end
