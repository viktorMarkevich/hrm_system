# config valid only for current version of Capistrano
# lock '3.9.0'

set :application, 'faceit-hrm'
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, -> { "2.4.0@#{fetch(:application)} --create" }

# Default value for :format is :pretty
set :format, :pretty

# Default value for :linked_files is []; # Default value for linked_dirs is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', 'config/puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :puma_conf, -> { "#{fetch(:deploy_to)}/current/config/puma.rb" }
set :puma_pid, -> { "#{fetch(:deploy_to)}/shared/pids/puma.pid" }
set :puma_sockets, -> { "#{fetch(:deploy_to)}/shared/tmp/sockets/puma.sock" }
set :puma_jungle_conf, '/etc/puma.conf'
set :puma_run_path, '/usr/local/bin/run-puma'

set :use_sudo, false

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
#
#   task :restart do
#     on "#{fetch(:user)}@192.168.0.251" do
#       execute "if [ -f #{fetch(:puma_pid)} ] && [ -e /proc/$(cat #{fetch(:puma_pid)}) ]; then kill -USR2 `cat #{fetch(:puma_pid)}`; else cd #{fetch(:deploy_to)}/current && bundle exec puma -c #{fetch(:puma_conf)} -E #{fetch(:rails_env)} -D; fi"
#     end
#   end
#
#   task :start do
#     on roles [:web, :app] do
#       within "#{fetch(:deploy_to)}/current" do
#         execute :bundle,:exec, "puma -c #{fetch(:puma_conf)} -E #{fetch(:rails_env)} -D"
#       end
#     end
#   end
#
#   task :stop do
#     on "#{fetch(:user)}@192.168.0.251" do
#       execute "if [ -f #{fetch(:puma_pid)} ] && [ -e /proc/$(cat #{fetch(:puma_pid)}) ]; then kill -QUIT `cat #{fetch(:puma_pid)}`; fi"
#     end
#   end
#
#   task :reset do
#     on "#{fetch(:user)}@192.168.0.251" do
#       within "#{fetch(:deploy_to)}/current" do
#         execute :bundle, :exec, "rake db:reset RAILS_ENV=#{fetch(:rails_env)}"
#       end
#     end
#   end
#
  task :any_task do #здесь можно размещать любые таски, которые нужно запустить в той или иной среде
    on "#{fetch(:user)}@192.168.0.251" do
      within "#{fetch(:deploy_to)}/current" do
        # execute :bundle, :exec, "rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}"
        execute :bundle, :exec, "rails s puma -d -p 3002 -e #{fetch(:rails_env)}"
        # execute :bundle, :exec, "rake history:delete_all RAILS_ENV=staging"
      end
    end
  end
end