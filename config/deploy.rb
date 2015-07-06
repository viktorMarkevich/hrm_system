# config valid only for Capistrano 3.4

SSHKit.config.command_map[:rake]  = 'bundle exec rake'

lock '3.4.0'

set :application, 'faceit-hrm'

# Система управления версиями
set :scm, :git
set :repo_url, 'git@bitbucket.org:hrm_system_team/faceit-hrm.git'

set :rvm_type, :user

set :rvm_ruby_version, 'ruby-2.2.2@faceit-hrm'      # Defaults to: 'default'


# Имя пользователя на сервере и папка с проектом
set :user, 'deployer'
set :deploy_to, "/home/deployer/#{fetch(:stage)}/faceit-hrm"

# Тип запуска Rails, метод доставки обновлений и локальные релизные версии
set :deploy_via, :remote_cache

set :linked_files, %w{config/database.yml .env config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"

set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 3
# RVM установлена не системно

set :assets_roles, [:web, :app]

namespace :deploy do
  task :restart do
    on "deployer@192.168.137.75" do
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
    on "deployer@192.168.137.75" do
      execute "if [ -f #{fetch(:unicorn_pid)} ] && [ -e /proc/$(cat #{fetch(:unicorn_pid)}) ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end
  task :reset do
    run "cd #{current_path} && bundle exec rake db:reset RAILS_ENV=#{fetch(:rails_env)}"
  end

  task :fill_in_vacancies do
    on roles [:web, :app] do
      execute "cd #{current_path} && bundle exec rake vacancies RAILS_ENV=#{fetch(:rails_env)}"
    end
  end
end
after "deploy:restart", "deploy:cleanup"