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
    run "cd #{current_path} && bundle exec rake db:reset RAILS_ENV=#{rails_env}"
  end
end
after "deploy:restart", "deploy:cleanup"
#after "deploy:update", "db:insert_statuses"

namespace :rake do
  # desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task
  # task :invoke do
  #   run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  # end

  desc 'Add user_id Vacancy'
  task vacancies: :environment do
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
    region = User.first.present? ? Region.first : Region.create(name: 'Херсон')
    user = User.first.present? ? User.first : User.create(email: 'test1@test.ts', password: '123456',
                                                          password_confirmation: '123456', first_name: 'test1',
                                                          last_name: 'test1', post: 'test1', region_id: region)

    Vacancy.find_each do |vacancy|
      vacancy.update(user_id: user.id)
    end
  end

  desc 'Add object image for each user'
  task add_object_img: :environment do
    User.all.each do |user|
      Image.create(user_id: user.id)
    end
  end
end
