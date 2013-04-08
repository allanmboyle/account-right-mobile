HttpServerManager.pid_dir = "#{Rails.root}/tmp/pids"
HttpServerManager.log_dir = "#{Rails.root}/log"

require File.expand_path('../services/rails_server', __FILE__)
require File.expand_path('../services/oauth_stub/server', __FILE__)
require File.expand_path('../services/oauth_stub/configurer', __FILE__)
require File.expand_path('../services/api_stub', __FILE__)
require File.expand_path('../services/api_stub/server', __FILE__)
require File.expand_path('../services/api_stub/customer_file_configurer', __FILE__)
require File.expand_path('../services/api_stub/contact_configurer', __FILE__)
require File.expand_path('../services/api_stub/configurer', __FILE__)
require File.expand_path('../services/no_op_service', __FILE__)
