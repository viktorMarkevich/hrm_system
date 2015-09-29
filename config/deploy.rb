# config valid only for Capistrano 3.4

SSHKit.config.command_map[:rake]  = 'bundle exec rake'

lock '3.4.0'

set :application, 'faceit-hrm'
set :using_rvm,   true
set :use_sudo, false

# Система управления версиями
set :scm, :git
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

# Имя пользователя на сервере и папка с проектом
set :user, fetch(:stage) == :production ? :admin : :deployer
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:stage)}/faceit-hrm"

set :rvm_type, :user
set :rvm_ruby_version, '2.2.2@faceit-hrm'      # Defaults to: 'default'

set :bundle_path, nil
set :bundle_binstubs, nil
set :bundle_flags, '--system'

# Тип запуска Rails, метод доставки обновлений и локальные релизные версии
set :deploy_via, :remote_cache

set :linked_files, %w{config/database.yml .env config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"

set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :copy_exclude, [ '.git' ]

set :keep_releases, 3

set :assets_roles, [:web, :app]

namespace :deploy do
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
after 'deploy:restart', 'deploy:cleanup'
