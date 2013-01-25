module AccountRight

  class Base
    include ActiveModel::Conversion

    def initialize(attributes = {})
      attributes.each { |key, value| send("#{key}=", value) } if attributes
    end

  end

end
