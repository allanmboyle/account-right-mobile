module Extensions
  module Core

    module Object

      def self.included(mod)
        begin
          require 'pty'
          mod.send(:include, Extensions::Core::Object::PTYCommandProcessor)
        rescue LoadError
          mod.send(:include, Extensions::Core::Object::IOCommandProcessor)
        end
      end

    end

  end
end

::Object.send(:include, Extensions::Core::Object)
