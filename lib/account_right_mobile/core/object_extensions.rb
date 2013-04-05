module AccountRightMobile
  module Core

    module ObjectExtensions

      def execute_with_logging(command)
        puts command
        `#{command}`.tap { |output| puts output }
      end

    end

  end
end

::Object.send(:include, AccountRightMobile::Core::ObjectExtensions)
