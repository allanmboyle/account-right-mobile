module AccountRightMobile
  module Faker

    class Money

      class << self

        def within(starting_price, ending_price)
          (starting_price + Random.rand((ending_price - starting_price).to_f)).round(2)
        end

        def random
          within(-10000, 10000)
        end

      end

    end

  end
end
