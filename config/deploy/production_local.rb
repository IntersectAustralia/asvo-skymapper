set :scm, :none
set :repository, "#{user_home}/code_base/#{application}-master/"
set :use_sudo, true
set :copy_dir, "#{user_home}/tmp/"
set :remote_copy_dir, "/tmp"
set :rails_env, "production"
set :stage, "production"
# Your HTTP server, Apache/etc
role :web, ''
# This may be the same as your Web server
role :app, ''
# This is where Rails migrations will run
role :db,  '', :primary => true