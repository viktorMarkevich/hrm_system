set :stage, :staging
set :branch, 'develop'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{deployer@192.168.137.75}
role :web, %w{deployer@192.168.137.75}
role :db,  %w{deployer@192.168.137.75}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a has can be used to set
# extended properties on the server.
server '192.168.137.75', user: 'deployer', roles: %w{web app}, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, {
                    forward_agent: true,
                    auth_methods: %w(publickey password),
                    password: ENV['STAGING_SSH_PASSWORD']
                  }
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

set :rails_env, :staging

namespace :rake do
  desc 'Add user_id Vacancy'
  task :vacancies  do
    region = Region.first_or_create!(name: 'Уругвай')
    user = User.first_or_create!(email: 'test1@test.ts', password: '123456',
                                 password_confirmation: '123456', first_name: 'test1',
                                 last_name: 'test1', post: 'test1', region_id: region)

    Vacancy.find_each do |vacancy|
      vacancy.update(user_id: user.id)
    end
  end

  desc 'Add object image for each user'
  task :add_object_img do
    User.all.each do |user|
      Image.create(user_id: user.id)
    end
  end
end