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
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', '.ruby-gemset', '.ruby-version')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :use_sudo, false

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  task :any_task do #здесь можно размещать любые таски, которые нужно запустить в той или иной среде
    on "#{fetch(:user)}@192.168.115.251" do
      within "#{fetch(:deploy_to)}/current" do
        # execute :bundle, :exec, "rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}"
        # execute :bundle, :exec, "rake history:delete_all RAILS_ENV=staging"
      end
    end
  end
end