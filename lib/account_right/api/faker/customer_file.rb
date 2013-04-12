module AccountRight
  module API
    module Faker

      class CustomerFile

        class << self

          def id
            "123aaaaa-bb98-21cc-dd89-eeeee#{next_counter.to_s.ljust(6, "0")}"
          end

          private

          def next_counter
            @counter ||= 0
            @counter += 1
          end

        end

      end

    end
  end
end
