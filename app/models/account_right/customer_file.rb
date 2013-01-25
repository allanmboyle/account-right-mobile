module AccountRight

  class CustomerFile < AccountRight::Base

    attr_accessor :name

    def initialize(attributes = {})
      super(attributes)
    end

  end

end
