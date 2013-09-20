require 'digest/md5'

# additional modules needed for digest auth of users from files
include_recipe 'apache2::mod_auth_digest'
include_recipe 'apache2::mod_authz_user'
include_recipe 'apache2::mod_authn_file'

# role-based merge: Add the needed port to role[logstash-server], 
# it will be merged with all role-level apache listen port settings
# node.normal['apache']['listen_ports'] = [node['kibana']['webserver_port'].to_s]

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['cb-logstash']['kibana']['password'] = secure_password

node.normal['kibana']['apache']['template_cookbook'] = 'cb-logstash'

include_recipe 'kibana::default'

file "#{node['apache']['dir']}/kibana.digest" do
  user 'root'
  group 'www-data'
  content "#{node['cb-logstash']['kibana']['user']}:kibana:#{Digest::MD5.hexdigest "#{node['cb-logstash']['kibana']['user']}:kibana:#{node['cb-logstash']['kibana']['password']}"}"
  mode "640"
end
