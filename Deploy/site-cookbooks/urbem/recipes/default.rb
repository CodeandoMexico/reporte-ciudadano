#
# Cookbook Name:: urbem
# Recipe:: default
#
# Copyright 2015, Cívica Digital
#
# AGPL License
#

chef_gem 'docker-api'
require 'docker'

include_recipe 'git'

if node["key_file"]
  secret = Chef::EncryptedDataBagItem.load_secrets("#{node["key_file"]["path"]}")
  creds = Chef::EncryptedDataBagItem.load("urbem", "keys", secret)
else
  creds = data_bag_item('keys', 'secret')
end



list_creds = [
  "MAILER_FROM=#{creds['email']}",
  "FACEBOOK_SECRET=#{creds['facebook']['secret']}",
  "FACEBOOK_KEY=#{creds['facebook']['key']}",
  "TWITTER_KEY=#{creds['twitter']['key']}",
  "TWITTER_SECRET=#{creds['twitter']['secret']}",
  "TWITTER_OAUTH_TOKEN=#{creds['twitter']['oauth_token']}",
  "TWITTER_OAUTH_TOKEN_SECRET=#{creds['twitter']['oauth_token_secret']}",
  "SENDGRID_USERNAME=#{creds['sendgrid']['username']}",
  "SENDGRID_PASSWORD=#{creds['sendgrid']['password']}",
  "COVERALLS_TOKEN=#{creds['coverall_token']}",
  "SECRET_KEY_BASE=#{creds['rails']['secret_key_base']}",
  "RAILS_ENV=#{creds['rails']['env']}",
  "PASSENGER_APP_ENV=#{creds['rails']['env']}",
  "POSTGRES_PASSWORD=#{creds['postgres']['password']}",
  "S3_BUCKET=#{creds['aws']['s3_bucket_name']}",
  "AWS_SECRET=#{creds['aws']['aws_secret']}",
  "AWS_KEY=#{creds['aws']['aws_key']}"
]

# Up the docker service
docker_service 'default' do
  action [:create, :start]
end

docker_image "postgres" do
  tag "9.4"
end

docker_image "redis" do
  tag "2"
end

docker_image "civicadigital/backup" do
  tag "latest"
end

docker_image "gliderlabs/logspout" do
  tag "latest"
end

docker_image "phusion/passenger-ruby22" do
  tag "latest"
end

docker_container "logs" do
  image "gliderlabs/logspout"
  tag "latest"
  container_name "logs"
  detach true
  volume ["/var/run/docker.sock:/tmp/docker.sock"]
  port "127.0.0.1:8000:80"
end

docker_container "postgres" do
  image "postgres"
  tag "9.4"
  container_name "postgres"
  detach true
  env "POSTGRES_PASSWORD=#{creds['postgres']['password']}"
end

docker_container "redis" do
  image "redis"
  tag "2"
  container_name "redis"
  detach true
end

docker_container "urbem_up" do
  action :start
  only_if do
    begin
      Docker::Conteiner.get("urbem-puebla")
      true
    rescue
      nil
    end
  end
end

directory "/var/urbem/" do
  owner "root"
  group "root"
  mode  "755"
  action :create
end

git "/var/urbem" do
  revision "master"
  repository "https://github.com/civica-digital/urbem-puebla.git"
  revision 'docker-support'
  notifies :run, "docker_container[commit_db]", :immediately
  action :sync
end

docker_container "commit_db" do
  image "civicadigital/backup"
  env ["AWS_KEY=#{creds['aws']['aws_key']}",
       "AWS_SECRET=#{creds['aws']['aws_secret']}",
       "S3_BUCKET=#{creds['aws']['s3_bucket_backup_name']}"]
  link ["postgres:postgres", "redis:redis"]
  remove_automatically true
  command ""
  container_name "backup_db"
  action :nothing
  notifies :build,  "docker_image[urbem-puebla]", :immediately
end

docker_image 'urbem-puebla' do
  tag 'latest'
  source "/var/urbem"
  action :nothing
  notifies :run, 'docker_container[urbem_create]', :immediately
end


docker_container 'urbem_create' do
  image "urbem-puebla"
  entrypoint "rake"
  command "db:create"
  container_name "create_dbs"
  link ["postgres:postgres", "redis:redis"]
  remove_automatically true
  env list_creds
  action :nothing
  notifies :run, "docker_container[urbem_migrate]", :immediately
end

docker_container 'urbem_migrate' do
  image "urbem-puebla"
  entrypoint "rake"
  command "db:migrate"
  link ["postgres:postgres", "redis:redis"]
  container_name "migrate_dbs"
  remove_automatically true
  env  list_creds
  action :nothing
  notifies :redeploy, "docker_container[urbem]", :immediately
end

docker_container "urbem" do
  image "urbem-puebla"
  container_name "urbem"
  link ["postgres:postgres", "redis:redis"]
  env  list_creds
  detach true
  port ['80:80', "443:443"]
  notifies :redeploy, "docker_container[sidekiq]", :immediately
  action :run
end

docker_container "sidekiq" do
  image "urbem-puebla"
  container_name "sidekiq"
  link ["postgres:postgres", "redis:redis"]
  env list_creds
  detach true
  entrypoint "sidekiq"
  action :run
end
