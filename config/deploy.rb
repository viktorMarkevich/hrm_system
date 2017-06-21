# config valid only for current version of Capistrano
lock '3.7.2'

# set :application, 'my_app_name'
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

# deploy.rb or stage file (staging.rb, production.rb or else)
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, -> { "2.4.0@#{fetch(:application)} --create" }

set :tmp_dir, -> { "/home/#{fetch(:user)}/tmp" }

# Default value for :format is :pretty
set :format, :pretty

# Default value for :linked_files is []; # Default value for linked_dirs is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', '.ruby-version', '.ruby-gemset', 'config/unicorn.rb')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', '.env', '.ruby-version', '.ruby-gemset', 'config/unicorn.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :unicorn_conf, -> { "#{fetch(:deploy_to)}/current/config/unicorn.rb" }
set :unicorn_pid, -> { "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid" }
set :unicorn_sockets, -> { "#{fetch(:deploy_to)}/shared/tmp/sockets/unicorn.sock" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  task :restart do
    on "#{fetch(:user)}@192.168.0.251" do
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
    on "#{fetch(:user)}@192.168.0.251" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

  task :reset do
    on "#{fetch(:user)}@192.168.0.251" do
      within "#{fetch(:deploy_to)}/current" do
        execute :bundle, :exec, "rake db:reset RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  task :any_task do #здесь можно размещать любые таски, которые нужно запустить в той или иной среде
    on "#{fetch(:user)}@192.168.0.251" do
      within "#{fetch(:deploy_to)}/current" do
        # execute :bundle, :exec, "rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}"
        # execute :bundle, :exec, "setsid rails s -p3001 -e #{fetch(:rails_env)}"
        #  execute :bundle, :exec, "setsid unicorn_rails -p 3001 -E #{fetch(:rails_env)}"
        execute :bundle, :exec, "rake history:delete_all RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

end