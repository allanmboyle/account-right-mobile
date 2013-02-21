module AccountRightMobile

  class Npm

    class Package

      def initialize(name)
        @name = name
      end

      def uninstall_if_required!
        uninstall! if uninstall_required?
      end

      def to_yml
        "#{@name}: #{intended_commit_ish}"
      end

      private

      def uninstall!
        execute_with_logging("npm uninstall #{@name}")
      end

      def uninstall_required?
        installed? && (current_commit_ish.nil? || (intended_commit_ish != current_commit_ish))
      end

      def installed?
        File.exists?("#{Npm.root}/#{@name}")
      end

      def intended_commit_ish
        PackageFile.commit_ish_of(@name)
      end

      def current_commit_ish
        CommitIshRegistryFile.commit_ish_of(@name)
      end

    end

    class PackageFile

      class << self

        COMMIT_ISH_REGEXP = /\.git#([0-9a-f]*)$/

        def packages_with_commmit_ish
          all_dependencies.map do |name, version_info|
            version_info =~ COMMIT_ISH_REGEXP ? Package.new(name) : nil
          end.compact
        end

        def commit_ish_of(package_name)
          if all_dependencies[package_name]
            version_info = all_dependencies[package_name]
            commit_ish_match = version_info.match(COMMIT_ISH_REGEXP)
            commit_ish_match ? commit_ish_match[1] : nil
          else
            nil
          end
        end

        private

        def all_dependencies
          content_hash["dependencies"].merge(content_hash["devDependencies"])
        end

        def content_hash
          @content_hash ||= JSON.parse(File.read("#{Rails.root.join("package.json")}"))
        end

      end

    end

    class CommitIshRegistryFile

      class << self

        FILE_DIRECTORY = Rails.root.join(".node")
        FILE_PATH = "#{FILE_DIRECTORY}/package_commit_ish_registry.yml"

        def update(commit_ish_packages)
          FileUtils.mkdir_p(FILE_DIRECTORY)
          File.open(FILE_PATH, "w") do |file|
            commit_ish_packages.each { |package| file.write(package.to_yml) }
          end
        end

        def commit_ish_of(package_name)
          registry_hash[package_name] || nil
        end

        private

        def registry_hash
          File.exists?(FILE_PATH) ? YAML.load_file(FILE_PATH) : {}
        end

      end

    end

    class << self

      def install_if_possible
        if installed?
          ensure_forked_packages_will_be_up_to_date
          execute_with_logging("npm install")
          record_forked_package_versions
        end
      end

      def root
        Rails.root.join("node_modules")
      end

      private

      def installed?
        @installed ||= begin
          execute_with_logging("npm -v")
          puts "npm detected"
          true
        rescue
          puts "npm not detected"
          false
        end
      end

      def ensure_forked_packages_will_be_up_to_date
        PackageFile.packages_with_commmit_ish.each { |package| package.uninstall_if_required! }
      end

      def record_forked_package_versions
        CommitIshRegistryFile.update(PackageFile.packages_with_commmit_ish)
      end

    end

  end

end
