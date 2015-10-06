# config valid only for current version of Capistrano
lock '3.4.0'

# set :application, 'my_app_name'
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

# Default value for :scm is :git
set :scm, :git

# deploy.rb or stage file (staging.rb, production.rb or else)
set :rvm_type, :user                     # Defaults to: :auto

# Default value for :format is :pretty
set :format, :pretty

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', 'config/unicorn.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for keep_releases is 5
set :keep_releases, 3

set :unicorn_conf, -> { "/home/#{fetch(:user)}/#{fetch(:rails_env)}/#{fetch(:application)}/current/config/unicorn.rb" }
set :unicorn_pid, -> { "/home/#{fetch(:user)}/#{fetch(:rails_env)}/#{fetch(:application)}/shared/tmp/pids/unicorn.pid" }

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end

  task :restart do
    on "#{fetch(:user)}@192.168.137.75" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D; fi"
    end
  end

  task :start do
    on roles [:web, :app] do
      within "#{fetch(:deploy_to)}/current" do
        execute :bundle,:exec, "unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rails_env)} -D"
      end
    end
  end

  task :stop do
    on "#{fetch(:user)}@192.168.137.75" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

  task :reset do
    on "#{fetch(:user)}@192.168.137.75" do
      within "#{fetch(:deploy_to)}/current" do
        execute :bundle, :exec, "rake db:reset RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  task :any_task do #здесь можно размещать любые таски, которые нужно запустить в той или иной среде
    on "#{fetch(:user)}@192.168.137.75" do
      within "#{fetch(:deploy_to)}/current" do
        # execute :bundle, :exec, "rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}"
        execute :bundle, :exec, "rake db:seed RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

end
