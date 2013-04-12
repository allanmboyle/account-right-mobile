module Extensions
  module Core
    module Object

      module IOCommandProcessor

        def execute_with_logging(command)
          puts command
          command_output = ""
          IO.popen(command) do |io|
            io.each_line do |line|
              puts line
              command_output << line
            end
          end
          command_output
        end

      end

    end
  end
end
