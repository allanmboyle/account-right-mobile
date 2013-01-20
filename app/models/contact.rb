class Contact
  include ActiveModel::Conversion

  attr_accessor :name, :type, :balance

  def initialize(attributes = {})
    attributes.each { |key, value| send("#{key}=", value) } if attributes
  end

end
