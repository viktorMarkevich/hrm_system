# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :rails_env, 'staging'
set :branch, 'develop'
set :user, 'stagin'

set :deploy_to,  "/home/stagin/www/#{fetch(:application)}"

# Defaults to [:web]
set :assets_roles, [ :web, :app ]

role :app, %w{stagin@192.168.115.251}
role :web, %w{stagin@192.168.115.251}
role :db,  %w{stagin@192.168.115.251}

# Custom SSH Options
# ------------------------------------
server 'stagin@192.168.115.251',
       user: 'stagin',
       roles: %w{app web}