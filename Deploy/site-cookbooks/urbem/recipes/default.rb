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

docker_container "postgres" do
  image "postgres"
  tag "9.4"
  container_name "postgres"
  detach true
  env "POSTGRES_PASSWORD=#{list_creds["postgres"]["password"]}"
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
  notifies :build, "docker_image[urbem-puebla]", :immediately
  action :sync
end

docker_container "commit db" do
  action :nothing
  image "civicadigital/backup"
  container_name "backup_db"
  env ["AWS_KEY=#{creds[:aws][:aws_key]}",
       "AWS_SECRET=#{creds[:aws][:aws_secret]}",
       "S3_BUCKET=#{creds[:aws][:s3_bucket_backup_name]}"]
  link "postgres"
  remove_automatically true
  notifies :run,  "docker_image[urbem-puebla]", :immediately
end

docker_image 'urbem-puebla' do
  tag 'latest'
  source "/var/urbem"
  action :nothing
  notifies :run, 'docker_container[urbem_create]', :immediately
end

docker_image 'urbem_create' do
  image "urbem-puebla:test"
  command "rake db:create"
  link ["postgres", "redis"]
  remove_automatically true
  env list_creds
  action :nothing
  notifies :run, "docker_container[urbem_migrate]", :immediately
end

docker_container 'urbem_migrate' do
  image "urbem-puebla:latest"
  command "rake db:migrate"
  link ["postgres-test", "redis-test"]
  remove_automatically true
  env  list_creds
  action :nothing
  notifies :redeploy, "docker_container[urbem]", :inmediatly
end

docker_container "urbem" do
  image "urbem-puebla:latest"
  container_name "urbem"
  link ["postgres", "redis"]
  env  list_creds
  notifies :redeploy, "docker_container[sidekiq]", :inmediatly
end

docker_container "sidekiq" do
  image "urbem-puebla:test"
  container_name "sidekiq"
  link ["postgres", "redis"]
  env list_creds
end
