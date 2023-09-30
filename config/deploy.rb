# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "co_traveller"
set :repo_url, "git@github.com:santattech/co_traveller.git"
# set :repo_tree, "sm"
# set :deploy_to, "/home/ubuntu/projects/lp"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
#set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
#set :deploy_via, :export
set :use_sudo, false

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.0.0'
set :pty, false
set :linked_files, %w{config/secrets.yml .env.production}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :ssh_options, {
      forward_agent: true,
      auth_methods: ["publickey"],
      keys: ["aws-location.pem.pem"]
    }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'task_existing_data:test_user_table'
      # end
    end
  end
end

# namespace :rake do
#   desc "Run a task on a remote server."
#   # run like: cap staging rake:invoke task=a_certain_task
#   task :invoke do
#     run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
#   end
# end
