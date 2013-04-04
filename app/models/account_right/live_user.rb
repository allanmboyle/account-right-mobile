module AccountRight

  class LiveUser < Model::Base

    attr_accessor :username, :password

    def initialize(attributes = {})
      super(attributes)
    end

    def login
      AccountRight::OAuth.login(username, password)
    end

  end

end
