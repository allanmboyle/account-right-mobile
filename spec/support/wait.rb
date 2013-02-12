module AccountRightMobile
  class Wait

    class << self

      attr_accessor :default_timeout_in_seconds

      def until!(description, &block)
        until_true!(description) do
          block.call
          true
        end
      end

      def until_true!(description, &block)
        start_time = Time.now
        last_exc = nil
        while true
          begin
            return if block.call
          rescue => exc
            last_exc = exc
          end
          elapsed_time = Time.now - start_time
          if elapsed_time >= self.default_timeout_in_seconds
            failure_message = "Timed-out waiting until '#{description}'"
            failure_message << ".  Last observed exception: #{last_exc}" if last_exc
            raise failure_message
          end
        end
      end

    end

    self.default_timeout_in_seconds = 20

  end
end
