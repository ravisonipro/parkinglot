
server '35.165.153.160', roles: [:web, :app, :db], primary: true

lock '3.6.1'

set :application, 'parkinglotbuddy'
set :repo_url, 'https://vinayror:Rordeveloper12345@bitbucket.org/vinayror/parking_lot_buddy.git'

# set :git_https_username, ENV["GIT_USERNAME"]
# set :git_https_password, ENV["GIT_PASS"]               

# Default deploy_to directory is /var/var/www/my_app
set :deploy_to, '/var/www/parkinglotbuddy'
#set :linked_dirs, fetch(:linked_dirs, []).push('public/uploads')

# Default value for :scm is :git
set :scm, :git
set :branch, "master"
set :user, 'deploy'
set :use_sudo, true
set :rails_env, "production"
set :keep_releases, 5
# set :tmp_dir, "/home/deploy/tmp"
# set :ssh_options, { forward_agent: true, user: fetch(:user), keys: ["/home/affi/affimintus/pribeautyapp.pem"] }

set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :rvm_ruby_version, 'ruby-2.3.1@parking_lot_buddy'
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/uploads')
# set :linked_files, %w{/var/www/pribeautyapp/shared/config}
# set :linked_dirs, %w{vendor}
# set :unicorn_service, -> { "unicorn_#{fetch(:application)}" }
SSHKit.config.umask = '077'

namespace :deploy_callbacks do

  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   on roles(:deploy_server) do
  #     execute "/etc/init.d/unicorn_#{application} #{command}"
  #   end
  # end

  # on roles(:deploy_server) do
  #   # symlink the unicorn init file in /etc/init.d/
  #   execute sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #   # create a shared directory to keep files that are not in git and that are used for the application
  # end


   desc "to update"
   task :fix do
    on roles(:deploy_server) do
      update
    end
   end

  # desc "Symlink shared directories specific to the application"
  # task :symlink do
  #   on release_roles :all do
  #     execute :ln, "-nfs", "/var/www/talkblox_new/shared/system", "/var/www/talkblox_new/current/public/system"
  #     execute :ln, "-nfs", "/var/www/talkblox_new/shared/log/production.log", "/var/www/talkblox_new/current/log/production.log"
  #   end
  # end

  desc "to install the gem"
  task :bundle_gems do
    on roles(:deploy_server) do
       execute "cd #{deploy_to}/current && RAILS_ENV=production bundle install --path vendor/gems"
    end
  end

  desc "to cleanup the server"
  task :cleanup do
     on roles(:deploy_server) do
        execute "cd #{deploy_to}/current && RAILS_ENV=production rake db:reset"
     end
  end

  desc "to start"
  task :start do ; end

  desc "to stop"
  task :stop do ; end

  desc "to restart"
  task :restart do
    on roles(:deploy_server) do
      # execute "touch #{File.join(shared_path,'tmp','restart.txt')}"
    end
  end

end

  #after "deploy", "deploy_callbacks:bundle_gems"
  #after "deploy_callbacks:bundle_gems", "deploy_callbacks:restart"
# namespace :deploy do
#   task :restart do
#     invoke 'unicorn:stop'
#     invoke 'unicorn:reload'
#   end

#   task :stop do
#     invoke 'unicorn:stop'
#   end
# end
