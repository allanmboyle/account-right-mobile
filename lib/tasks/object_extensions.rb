module ObjectExtensions

  def self.included(other_mod)
    other_mod.send(:include, InstanceMethods)
  end

  module InstanceMethods

    def execute_with_logging(command)
      puts "Executing #{command}..."
      `#{command}`.tap { |output| puts output }
    end

  end

end

::Object.send(:include, ObjectExtensions)