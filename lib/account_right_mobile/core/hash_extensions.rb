module AccountRightMobile
  module Core

    module HashExtensions

      def nested_merge(other_hash)
        merger = proc do |key, old_value, new_value|
          old_value.is_a?(Hash) && new_value.is_a?(Hash) ? old_value.merge(new_value, &merger) : new_value
        end
        self.merge(other_hash, &merger)
      end

    end

  end
end

::Hash.send(:include, AccountRightMobile::Core::HashExtensions)
