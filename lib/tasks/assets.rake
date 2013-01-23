namespace(:assets) do

  APP_JAVASCRIPTS_DIR = Rails.root.join("app", "assets", "javascripts")
  VENDOR_JAVASCRIPTS_DIR = Rails.root.join("vendor", "assets", "javascripts")
  BUILD_ASSETS_DIR = Rails.root.join("tmp", "assets")
  BUILD_JAVASCRIPTS_DIR = BUILD_ASSETS_DIR.join("javascripts")
  COMPILED_JAVASCRIPTS_DIR = BUILD_JAVASCRIPTS_DIR.join("compiled")
  UNOPTIMIZED_JAVASCRIPTS_DIR = BUILD_JAVASCRIPTS_DIR.join("unoptimized")
  OPTIMIZED_JAVASCRIPTS_DIR = BUILD_JAVASCRIPTS_DIR.join("optimized")
  PUBLIC_ASSETS_DIR = Rails.root.join("public", "assets")
  CONFIG_DIR = Rails.root.join("config")

  directory "tmp/assets/javascripts/compiled"
  directory "tmp/assets/javascripts/unoptimized"
  directory "tmp/assets/javascripts/optimized"

  task(:clean) { rm_rf(BUILD_ASSETS_DIR) }

  task(:precompile => %w{ assets:compile assets:optimize assets:publish })

  desc "All compilation steps"
  task(:compile => "assets:compile:coffeescript")

  namespace(:compile) do

    desc "CoffeeScript compilation"
    task("coffeescript" => %w{ tmp/assets/javascripts/compiled npm:install }) do
      puts "Compiling CoffeeScript..."
      destination_directory = COMPILED_JAVASCRIPTS_DIR
      output = execute_with_logging "#{NODE_BIN_DIR.join("coffee")} --lint --compile --output #{destination_directory} #{APP_JAVASCRIPTS_DIR} 2>&1"
      raise "CoffeeScript compilation failed" if (output =~ /error/i) || (output =~ /warning/i)
      remove_duplicate_js_extension_from_files_in(destination_directory)
    end

  end

  desc "All optimization steps"
  task(:optimize => "assets:optimize:javascript")

  namespace(:optimize) do

    desc "Optimize Javascript"
    task(:javascript => %w{ tmp/assets/javascripts/unoptimized tmp/assets/javascripts/optimized npm:install }) do
      puts "Optimizing Javascript..."
      cp_r("#{COMPILED_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r_preserving_directory_structure(Dir.glob("#{APP_JAVASCRIPTS_DIR}/**/*.tmpl"),
                                          base_dir: APP_JAVASCRIPTS_DIR, to_dir: UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r("#{VENDOR_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      execute_with_logging "node #{CONFIG_DIR}/r.js -o #{CONFIG_DIR}/build.js"
    end

  end

  desc "Publishes assembled assets"
  task(:publish) { cp_r("#{OPTIMIZED_JAVASCRIPTS_DIR}/.", PUBLIC_ASSETS_DIR) }

  private

  def cp_r_preserving_directory_structure(files, options)
    files.each { |file| cp(file.to_s, file.to_s.sub(options[:base_dir].to_s, options[:to_dir].to_s)) }
  end

  def remove_duplicate_js_extension_from_files_in(directory)
    FileList["#{directory}/**/*.js"].each { |file| mv(file, file.gsub(/\.js$/, "")) }
  end

end
