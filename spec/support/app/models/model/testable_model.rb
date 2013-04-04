module Model

  class TestableModel < Model::Base

    attr_accessor :attribute1, :attribute2, :attribute3

    def initialize(attributes)
      super(attributes)
    end

  end

end
