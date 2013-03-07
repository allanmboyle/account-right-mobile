module AccountRightMobile
  module Services

    class ApiStubConfigurer
      include ::HttpStub::Configurer

      URI = "/"

      host "localhost"
      port 3003
    end

  end
end
