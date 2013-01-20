class CustomerFile
  include ActiveModel::Conversion

  attr_accessor :name

  def initialize(attributes = {})
    attributes.each { |key, value| send("#{key}=", value) } if attributes
  end

end
