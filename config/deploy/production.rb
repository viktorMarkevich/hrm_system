set :stage, 'production'
set :branch, 'master'

set :user, 'admin'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{admin@192.168.137.75}
role :web, %w{admin@192.168.137.75}
role :db,  %w{admin@192.168.137.75}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a has can be used to set
# extended properties on the server.
server '192.168.137.75', user: fetch(:user), roles: %w{web app db},
       ssh_options: { user: 'admin', # overrides user setting above
                      keys: %w(/home/admin/.ssh/id_rsa),
                      forward_agent: false,
                      auth_methods: %w(publickey),
                      # password: ENV['PRODUCTION_SSH_PASSWORD']
                       }

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally

# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

set :rails_env, :production