# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :rails_env, 'production'
set :branch, 'master'
set :user, 'production'

set :deploy_to,  "/home/#{fetch(:user)}/#{fetch(:application)}"

# Defaults to 'db'
# set :migration_role, 'migrator'

# Defaults to [:web]
set :assets_roles, [ :web, :app ]

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{production@192.168.0.251}
role :web, %w{production@192.168.0.251}
role :db,  %w{production@192.168.0.251}

# Custom SSH Options
# ------------------------------------
server 'production@192.168.0.251',
       user: 'production',
       roles: %w{web app}
       # ssh_options: { keys: %w(/home/production/.ssh/id_rsa),
       #                forward_agent: true,
       #                auth_methods: %w(publickey password),
       #                password: ENV['PRODUCTION_SSH_PASSWORD'] }