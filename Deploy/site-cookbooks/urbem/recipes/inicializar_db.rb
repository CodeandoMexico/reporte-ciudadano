Chef::Resource::DockerContainer.send(:include, Creds::Helper)

docker_container 'setup_migrate' do
  image "urbem-puebla"
  entrypoint "rake"
  command "db:setup"
  link ["postgres:postgres", "redis:redis"]
  container_name "setup_dbs"
  remove_automatically true
  env  list_creds
  action :nothing
  cmd_timeout 1000
end
