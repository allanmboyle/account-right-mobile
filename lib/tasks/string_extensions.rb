module AccountRightMobile
  module StringExtensions

    def self.included(other_mod)
      other_mod.send(:include, InstanceMethods)
    end

    module InstanceMethods

      def contains_execution_error?
        self =~ /no such file or directory/i || self =~ /command not found/
      end

    end

  end
end

::String.send(:include, AccountRightMobile::StringExtensions)
