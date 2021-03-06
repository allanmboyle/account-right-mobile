require 'simplecov'
SimpleCov.start do # Based on the rails adapter
  load_adapter 'test_frameworks'

  RAILS_CONFIG_DIR = File.expand_path("../../config", __FILE__)
  add_filter do |file|
    file.filename.starts_with?(RAILS_CONFIG_DIR) && !file.filename.include?("config_customizations")
  end
  add_filter '/db/'
  add_filter '/lib/account_right/.*/stub/.*configurer.*'  # Stubs are configured out-of-process
  add_filter '/lib/.*/pty_.*'                             # PTY not supported on all OS's
  add_filter '/vendor/bundle/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Initializers', 'config/initializers'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'

  minimum_coverage 100
  refuse_coverage_drop
end if ENV["coverage"]
