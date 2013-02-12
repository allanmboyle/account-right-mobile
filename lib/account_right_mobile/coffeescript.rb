module AccountRightMobile
  class CoffeeScript

    class << self

      def compile(options)
        coffee_script_path = AccountRightMobile::Npm.root.join("coffee-script", "bin", "coffee")
        output = execute_with_logging "node #{coffee_script_path} --lint --compile --output #{options[:dest_dir]} #{options[:src_dir]} 2>&1"
        raise "CoffeeScript compilation failed" if (output =~ /error/i) || (output =~ /warning/i)
        remove_duplicate_js_extension_from_files_in(options[:dest_dir])
      end

      private

      def remove_duplicate_js_extension_from_files_in(directory)
        Rake::FileList["#{directory}/**/*.js"].each { |file| FileUtils.mv(file, file.gsub(/\.js$/, "")) }
      end

    end

  end
end
