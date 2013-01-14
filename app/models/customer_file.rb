class CustomerFile
  include ActiveModel::Conversion

  attr_accessor :name

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) } if attributes
  end

end
