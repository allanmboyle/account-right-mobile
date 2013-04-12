module AccountRight
  module API

    class Exception < ::Exception

      def initialize(message)
        super(message)
      end

    end

  end
end
