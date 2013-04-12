module Extensions
  module Core

    module String

      def contains_execution_error?
        self =~ /no such file or directory/i || self =~ /command not found/
      end

    end

  end
end

::String.send(:include, Extensions::Core::String)
