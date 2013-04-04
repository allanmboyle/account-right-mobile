module AccountRightMobile
  module Services

    class NoOpService

      def self.method_missing(*args)
        self.new
      end

      def initialize(*args)
        # Intentionally blank
      end

      def method_missing(*args)
        self
      end

    end

  end
end
