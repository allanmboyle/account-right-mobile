Bundler.setup(:stub_services)
require 'faker'
require 'http_server_manager'
require 'http_stub'

HttpServerManager.pid_dir = "#{Rails.root}/tmp/pids"
HttpServerManager.log_dir = "#{Rails.root}/log"

Faker::Config.locale = "en-au"
require File.expand_path('../../extensions/faker', __FILE__)
require File.expand_path('../../account_right/api/faker/customer_file', __FILE__)
require File.expand_path('../../account_right/api/data_factory', __FILE__)

require File.expand_path('../services/rails_server', __FILE__)
require File.expand_path('../../account_right/oauth/stub/server', __FILE__)
require File.expand_path('../../account_right/oauth/stub/configurer', __FILE__)
require File.expand_path('../../account_right/api/stub', __FILE__)
require File.expand_path('../../account_right/api/stub/server', __FILE__)
require File.expand_path('../../account_right/api/stub/customer_file_configurer', __FILE__)
require File.expand_path('../../account_right/api/stub/contact_configurer', __FILE__)
require File.expand_path('../../account_right/api/stub/configurer', __FILE__)
require File.expand_path('../services/no_op_service', __FILE__)
