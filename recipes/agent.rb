include_recipe "python::pip"
include_recipe "logstash::agent"

# Get all openstack services loaded by this node.
node_services = node["cb-logstash"]["openstack"]["services"].select{ |s| File.exists?("/opt/cloudbau/#{s}-virtualenv") }

node_services.each do |srv_name|
  # XXX(mouad): logstasher python package should be already installed when
  # the cloudbau Ubuntu package was installed.
  node.override[srv_name]["logging.conf"]["formatter"] = "logstasher.LogStashFormatter"
  node.override[srv_name]["logging.conf"]["use"] = true
  node.override[srv_name]["syslog"]["use"] = false
end

# Get ip used by elasticsearch.
node.set['logstash']['elasticsearch_ip'] = search(:node, "roles:logstash-server AND chef_environment:#{node.chef_environment}").first.ipaddress
node.set['logstash']['elasticsearch_port'] = 9200  # XXX: Port is hard coded here.

node_services.each do |srv_name|
  node.set['logstash']['agent']['inputs'].push({
    'file' => {
      'type' => srv_name,
      'start_position' => 'beginning',
      'path' => node[srv_name]['logging.conf']['logfile'],
      'format' => "json_event"
    }
  })
end

node.set['logstash']['agent']['outputs'].push({
  'elasticsearch_http' => {
    'host' => "#{node['logstash']['elasticsearch_ip']}",
    'port' => "#{node['logstash']['elasticsearch_port']}",
    'flush_size' => 1
  }
})
