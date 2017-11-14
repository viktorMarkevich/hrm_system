# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :rails_env, 'staging'
set :branch, 'develop'
set :user, 'staging'

set :deploy_to,  "/home/#{fetch(:user)}/www/#{fetch(:application)}"

# Defaults to [:web]
set :assets_roles, [ :web, :app ]

role :app, %w{staging@192.168.115.251}
role :web, %w{staging@192.168.115.251}
role :db,  %w{staging@192.168.115.251}

# Custom SSH Options
# ------------------------------------
server 'staging@192.168.115.251',
       user: 'staging',
       roles: %w{web app}