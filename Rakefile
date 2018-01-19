require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require './controllers/application_controller'
  end
end

task :default => ['db:migrate']
