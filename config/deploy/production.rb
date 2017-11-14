# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :rails_env, 'production'
set :branch, 'master'
set :user, 'production'

set :deploy_to,  "/home/production/www/#{fetch(:application)}"

# Defaults to [:web]
set :assets_roles, [ :web, :app ]

role :app, %w{production@192.168.115.251}
role :web, %w{production@192.168.115.251}
role :db,  %w{production@192.168.115.251}

# Custom SSH Options
# ------------------------------------
server 'production@192.168.115.251',
       user: 'production',
       roles: %w{web app}