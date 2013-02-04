namespace(:assets) do

  APP_JAVASCRIPTS_DIR = Rails.root.join("app", "assets", "javascripts")
  VENDOR_JAVASCRIPTS_DIR = Rails.root.join("vendor", "assets", "javascripts")
  BUILD_ASSETS_DIR = Rails.root.join("tmp", "assets")
  BUILD_ASSETS_JAVASCRIPTS_DIR = BUILD_ASSETS_DIR.join("javascripts")
  COMPILED_JAVASCRIPTS_DIR = BUILD_ASSETS_JAVASCRIPTS_DIR.join("compiled")
  UNOPTIMIZED_JAVASCRIPTS_DIR = BUILD_ASSETS_JAVASCRIPTS_DIR.join("unoptimized")
  OPTIMIZED_JAVASCRIPTS_DIR = BUILD_ASSETS_JAVASCRIPTS_DIR.join("optimized")
  PUBLIC_ASSETS_DIR = Rails.root.join("public", "assets")
  CONFIG_DIR = Rails.root.join("config")
  BUILD_CONFIG_DIR = Rails.root.join("tmp", "config")

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

  task(:compile => "assets:compile:coffeescripts")

  namespace(:compile) do

    task(:coffeescripts => %w{ tmp/assets/javascripts/compiled node:required npm:install }) do
      AccountRightMobile::CoffeeScript.compile(src_dir: APP_JAVASCRIPTS_DIR,
                                               dest_dir: COMPILED_JAVASCRIPTS_DIR)
    end

  end

  task(:optimize => "assets:optimize:javascripts")

  namespace(:optimize) do

    task(:prepare => "tmp/config") do
      cp("#{CONFIG_DIR}/require_js_build.js", BUILD_CONFIG_DIR)
      cp(AccountRightMobile::Npm.root.join("requirejs", "bin", "r.js"), BUILD_CONFIG_DIR)
    end

    task(:javascripts => %w{ tmp/assets/javascripts/unoptimized
                             tmp/assets/javascripts/optimized
                             node:required
                             npm:install
                             assets:optimize:prepare }) do
      cp_r("#{COMPILED_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r_preserving_directory_structure(Dir.glob("#{APP_JAVASCRIPTS_DIR}/**/*.tmpl"),
                                          replace_dir: APP_JAVASCRIPTS_DIR, with_dir: UNOPTIMIZED_JAVASCRIPTS_DIR)
      cp_r("#{VENDOR_JAVASCRIPTS_DIR}/.", UNOPTIMIZED_JAVASCRIPTS_DIR)
      reducer_script_path = "#{BUILD_CONFIG_DIR}/r.js"
      config_script_path = "#{BUILD_CONFIG_DIR}/require_js_build.js"
      source_dir = "tmp/assets/javascripts/unoptimized"
      destination_dir = "tmp/assets/javascripts/optimized"
      execute_with_logging "node #{reducer_script_path} -o #{config_script_path} appDir=#{source_dir} dir=#{destination_dir} baseUrl=lib"
    end

  end

  task(:publish) { cp_r("#{OPTIMIZED_JAVASCRIPTS_DIR}/.", PUBLIC_ASSETS_DIR) }

  private

  def cp_r_preserving_directory_structure(files, options)
    files.each { |file| cp(file.to_s, file.to_s.sub(options[:replace_dir].to_s, options[:with_dir].to_s)) }
  end

end
