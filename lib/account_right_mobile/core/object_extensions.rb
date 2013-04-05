module AccountRightMobile
  module Core

    module ObjectExtensions

      def self.included(other_mod)
        other_mod.send(:include, InstanceMethods)
      end

      module InstanceMethods

        def execute_with_logging(command)
          puts command
          `#{command}`.tap { |output| puts output }
        end

      end

    end

  end
end

::Object.send(:include, AccountRightMobile::Core::ObjectExtensions)
