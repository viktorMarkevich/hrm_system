# config valid only for current version of Capistrano
lock '3.9.0'

set :application, 'faceit-hrm'
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, -> { "2.4.0@#{fetch(:application)}" }
# set :rvm_ruby_version, -> { "2.4.0@#{fetch(:application)}_#{fetch(:rails_env)} --create" }

# Default value for :format is :pretty
set :format, :pretty

# Default value for :linked_files is []; # Default value for linked_dirs is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', 'config/puma.rb',
                                                 '.ruby-version', '.ruby-gemset')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# set :puma_rackup, -> {"#{fetch(:deploy_to)}/current/config.ru" }
# set :puma_conf, -> { "#{fetch(:deploy_to)}/current/config/puma.rb" }
# set :puma_pid, -> { "#{fetch(:deploy_to)}/shared/tmp/pids/puma.pid" }
# set :puma_sockets, -> { "#{fetch(:deploy_to)}/shared/tmp/sockets/puma.sock" }
# set :puma_state, -> { "#{fetch(:deploy_to)}/shared/tmp/pids/puma.state" }
# set :puma_env, fetch(:rack_env, fetch(:rails_env))
#
# set :puma_jungle_conf, '/etc/puma.conf'
# set :puma_run_path, '/usr/local/bin/run-puma'

# set :use_sudo, false
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :puma_bind,       "unix://#{fetch(:deploy_to)}/shared/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{fetch(:deploy_to)}/shared/tmp/pids/puma.state"
set :puma_pid,        "#{fetch(:deploy_to)}/shared/tmp/pids/puma.pid"
set :puma_access_log, "#{fetch(:deploy_to)}/shared/log/puma.error.log"
set :puma_error_log,  "#{fetch(:deploy_to)}/shared/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
# set :nginx_sites_available_path, "/etc/nginx/sites-available"
# set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  task :any_task do #здесь можно размещать любые таски, которые нужно запустить в той или иной среде
    on "#{fetch(:user)}@192.168.115.251" do
      within "#{fetch(:deploy_to)}/current" do
        # execute :bundle, :exec, "rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}"
        execute :bundle, :exec, "rails s puma -d -p 3002 -e #{fetch(:rails_env)}"
        # execute :bundle, :exec, "rake history:delete_all RAILS_ENV=staging"
      end
    end
  end
end