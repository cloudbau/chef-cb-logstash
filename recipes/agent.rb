include_recipe "python::pip"
include_recipe "logstash::agent"

# FIXME(mouad): Think about a cleanest way to do this.
# Get available recipes from the run list.
recipes = Set.new(node.run_list.expand(node.chef_environment).recipes.map { |s| s.split("::")[0] })
# Get all openstack services loaded by this node.
node_services = node["cb-logstash"]["openstack"]["services"].select{ |s| recipes.include?(s) }

node_services.each do |srv_name|
  # XXX(mouad): logstasher python package should be already installed when
  # the cloudbau Ubuntu package was installed.
  node.override[srv_name]["logging.conf"]["formatter"] = "logstasher.LogStashFormatter"
  node.override[srv_name]["logging.conf"]["use"] = true
  node.override[srv_name]["syslog"]["use"] = false
end

# Get ip used by elasticsearch.
if node.roles.include? "logstash-server" then
  ipaddress = node['elasticsearch']['network.bind_host']
else
  ipaddress = search(:node, "roles:logstash-server AND chef_environment:#{node.chef_environment}").first['elasticsearch']['network.bind_host']
end

node.set['logstash']['elasticsearch_ip'] = ipaddress
node.set['logstash']['elasticsearch_port'] = 9200  # XXX: Port is hard coded here.


inputs =[] 
node_services.each do |srv_name|
  inputs.push({
    'file' => {
      'type' => srv_name,
      'start_position' => 'beginning',
      'path' => node[srv_name]['logging.conf']['logfile'],
      'format' => "json_event"
    }
  })
end
node.set['logstash']['agent']['inputs'] = inputs

node.set['logstash']['agent']['outputs'] = [{
  'elasticsearch_http' => {
    'host' => "#{node['logstash']['elasticsearch_ip']}",
    'port' => "#{node['logstash']['elasticsearch_port']}",
    'flush_size' => 1
  }
}]
