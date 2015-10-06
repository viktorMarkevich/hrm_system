# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
set :application, 'faceit-hrm'
set :rails_env, 'staging'
set :user, 'deployer'

# Defaults to 'db'
set :migration_role, 'migrator'

# Defaults to [:web]
set :assets_roles, [:web, :app]

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{deployer@192.168.137.75}
role :web, %w{deployer@192.168.137.75}
role :db,  %w{deployer@192.168.137.75}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.
set :deploy_to,  "/home/deployer/#{fetch(:rails_env)}/#{fetch(:application)}"

set :rvm_ruby_version, "2.2.2@#{fetch(:application)}"

set :branch, 'develop'

# Custom SSH Options
# ------------------------------------
server '192.168.137.75',
       user: 'deployer',
       roles: %w{app db web},
       ssh_options: {
           keys: %w(/home/deployer/.ssh/id_rsa),
           forward_agent: true,
           auth_methods: %w(publickey password),
           password: ENV['STAGING_SSH_PASSWORD']
       }
