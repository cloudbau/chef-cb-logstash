
include_recipe "kibana::default"

node.override['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['kibana']['webserver_port']]

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  cookbook "apache2"
  variables :apache_listen_ports => node['apache']['listen_ports'].map{|p| p.to_i}.uniq
  notifies :restart, "service[apache2]"
  mode 00644
end
