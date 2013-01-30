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
  BUILD_CONFIG_DIR = Rails.root.join("tmp", "config")

  NODE_MODULES_DIR = Rails.root.join("node_modules")
  NODE_EXTENSIONS_DIR = Rails.root.join("lib", "node")

  directory "tmp/assets/javascripts/compiled"
  directory "tmp/assets/javascripts/unoptimized"
  directory "tmp/assets/javascripts/optimized"
  directory "tmp/config"

  desc "Deletes generated assets"
  task(:clean) do
    [BUILD_ASSETS_DIR, BUILD_CONFIG_DIR].each { |dir| rm_rf(dir) }
  end

  desc "Compiles and optimizes JavaScript via RequireJS"
  task(:precompile => %w{ assets:compile assets:optimize assets:publish })

  task(:compile => "assets:compile:coffeescript")

  namespace(:compile) do

    task("coffeescript" => %w{ tmp/assets/javascripts/compiled node:required npm:install }) do
      destination_directory = COMPILED_JAVASCRIPTS_DIR
      output = execute_with_logging "node #{NODE_EXTENSIONS_DIR}/coffee-script/bin/coffee.js --lint --compile --output #{destination_directory} #{APP_JAVASCRIPTS_DIR} 2>&1"
      raise "CoffeeScript compilation failed" if (output =~ /error/i) || (output =~ /warning/i)
      remove_duplicate_js_extension_from_files_in(destination_directory)
    end

  end

  task(:optimize => "assets:optimize:javascript")

  namespace(:optimize) do

    task(:prepare => "tmp/config" ) do
      cp("#{CONFIG_DIR}/require_js_build.js", BUILD_CONFIG_DIR)
      cp("#{NODE_MODULES_DIR}/requirejs/bin/r.js", BUILD_CONFIG_DIR)
    end

    task(:javascript => %w{ tmp/assets/javascripts/unoptimized
                            tmp/assets/javascripts/optimized
                            node:required
                            npm:install
                            assets:optimize:prepare }) do
      cp_r("#{COMPILED_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r_preserving_directory_structure(Dir.glob("#{APP_JAVASCRIPTS_DIR}/**/*.tmpl"),
                                          replace_dir: APP_JAVASCRIPTS_DIR, with_dir: UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r("#{VENDOR_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      execute_with_logging "node #{BUILD_CONFIG_DIR}/r.js -o #{BUILD_CONFIG_DIR}/require_js_build.js appDir=tmp/assets/javascripts/unoptimized dir=tmp/assets/javascripts/optimized baseUrl=lib"
    end

  end

  task(:publish) { cp_r("#{OPTIMIZED_JAVASCRIPTS_DIR}/.", PUBLIC_ASSETS_DIR) }

  private

  def cp_r_preserving_directory_structure(files, options)
    files.each { |file| cp(file.to_s, file.to_s.sub(options[:replace_dir].to_s, options[:with_dir].to_s)) }
  end

  def remove_duplicate_js_extension_from_files_in(directory)
    FileList["#{directory}/**/*.js"].each { |file| mv(file, file.gsub(/\.js$/, "")) }
  end

end
