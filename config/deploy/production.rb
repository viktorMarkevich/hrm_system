# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :application, 'faceit-hrm'
set :rails_env, 'production'
set :branch, 'master'
set :user, 'admin'

set :deploy_to,  "/home/#{fetch(:user)}/#{fetch(:rails_env)}/#{fetch(:application)}"

# Defaults to 'db'
set :migration_role, 'migrator'

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{admin@192.168.137.75}
role :web, %w{admin@192.168.137.75}
role :db,  %w{admin@192.168.137.75}

# Custom SSH Options
# ------------------------------------
server '192.168.137.75',
       user: 'admin',
       roles: %w{app db web},
       ssh_options: {
           keys: %w(/home/admin/.ssh/id_rsa),
           forward_agent: true,
           auth_methods: %w(publickey password),
           password: ENV['PRODUCTION_SSH_PASSWORD']
       }