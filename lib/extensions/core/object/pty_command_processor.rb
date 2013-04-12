module Extensions
  module Core
    module Object

      module PTYCommandProcessor

        def execute_with_logging(command)
          puts command
          command_output = ""
          begin
            PTY.spawn(command) do |r, w, pid|
              begin
                r.each do |line|
                  puts line
                  command_output << line
                end
              rescue Exception
                # Intentionally blank
              end
            end
          rescue PTY::ChildExited
            # Intentionally blank
          end
          command_output
        end

      end

    end
  end
end
