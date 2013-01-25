module AccountRight

  class Contact < AccountRight::Base

    attr_accessor :name, :type, :balance

    def initialize(attributes = {})
      super(attributes)
    end

  end

end

