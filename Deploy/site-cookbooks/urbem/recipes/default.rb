#
# Cookbook Name:: urbem
# Recipe:: default
#
# Copyright 2015, Cívica Digital
#
# AGPL License
#

Chef::Resource::DockerContainer.send(:include, Creds::Helper)

chef_gem 'docker-api'
require 'docker'

include_recipe 'git'

# Up the docker service
docker_service 'default' do
  action [:create, :start]
end

docker_image "postgres" do
  tag "9.4"
  cmd_timeout 1800
end

docker_image "redis" do
  tag "2"
  cmd_timeout 1800
end

docker_image "civicadigital/backup" do
  tag "latest"
  cmd_timeout 1800
end

docker_image "gliderlabs/logspout" do
  tag "v2"
  cmd_timeout 1800
end

docker_image "phusion/passenger-ruby22" do
  tag "latest"
  cmd_timeout 1800
end

directory '/var/log/urbem' do
 owner 'root'
 group 'root'
 mode '0755'
 action :create
end

docker_container "logs" do
  image "gliderlabs/logspout"
  tag "v2"
  container_name "logs"
  detach true
  volume ["/var/run/docker.sock:/tmp/docker.sock", "/var/log/urbem:/mnt/routes"]
  port "127.0.0.1:8000:8000"
  cmd_timeout 600
end

docker_container "postgres" do
  image "postgres"
  tag "9.4"
  container_name "postgres"
  detach true
  env "POSTGRES_PASSWORD=#{postgres_pwd}"
  cmd_timeout 600
end

docker_container "redis" do
  image "redis"
  tag "2"
  container_name "redis"
  detach true
  cmd_timeout 600
end


directory "/var/urbem/" do
  owner "root"
  group "root"
  mode  "755"
  action :create
end

git "/var/urbem" do
  revision node["urbem"]["branch"]
  repository "https://github.com/civica-digital/urbem-puebla.git"
  notifies :run, "docker_container[commit_db]", :immediately
  action :sync
end


docker_container "commit_db" do
  image "civicadigital/backup"
  env list_creds
  #["AWS_KEY=#{creds['aws']['aws_key']}",
  #     "AWS_SECRET=#{creds['aws']['aws_secret']}",
  #     "S3_BUCKET=#{creds['aws']['s3_bucket_backup_name']}"]
  link ["postgres:postgres", "redis:redis"]
  remove_automatically true
  command ""
  container_name "backup_db"
  ignore_failure true
  action :nothing
  notifies :build,  "docker_image[urbem-puebla]", :immediately
  cmd_timeout 600
end

docker_image 'urbem-puebla' do
  tag 'latest'
  source "/var/urbem"
  begin
     Docker::Image.get("urbem-puebla")
     action :nothing
  rescue
     action :build
  end
  notifies :run, 'docker_container[urbem_create]', :immediately
  cmd_timeout 2400
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
  cmd_timeout 1000
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
  notifies :run, "docker_container[urbem]", :immediately
  cmd_timeout 1000
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
  cmd_timeout 600
end

docker_container "sidekiq" do
  image "urbem-puebla"
  container_name "sidekiq"
  link ["postgres:postgres", "redis:redis"]
  env list_creds
  detach true
  entrypoint "sidekiq"
  action :run
  cmd_timeout 600
end
