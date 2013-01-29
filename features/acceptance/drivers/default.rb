module AccountRightMobile
  module Acceptance
    module Drivers

      class Default < AccountRightMobile::Acceptance::Drivers::Base

        def self.name
          :default
        end

        def initialize(options)
          super(options[:app], :browser => options[:type])
        end

      end

    end
  end
end
