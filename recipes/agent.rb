include_recipe "python::pip"
include_recipe "logstash::agent"

# Get all openstack services loaded by this node.
node_services = node["cb-logstash"]["openstack"]["services"].select{ |s| node.has_key? s }

# Get ip used by elasticsearch.
node['logstash']['elasticsearch_ip'] = search(:node, "roles:logstash-server AND chef_environment:#{node.chef_environment}").first.ipaddress
node['logstash']['elasticsearch_port'] = 9200  # XXX: Port is hard coded here.

node_services.each do |srv_name|
  node['logstash']['agent']['inputs'].push({
    'file' => {
      'type' => srv_name,
      'start_position' => 'beginning',
      'path' => node[srv_name]['logging.conf']['logfile'],
      'format' => "json_event"
    }
  })
end

node['logstash']['agent']['outputs'].push({
  'elasticsearch_http' => {
    'host' => "#{node['logstash']['elasticsearch_ip']}:#{node['logstash']['elasticsearch_port']}",
    'flush_size' => 1
  }
})

node_services.each do |srv_name|
  # Install logstash logging formatter in all Python virtualenv.
  python_pip "install #{node["cb-logstash"]["logging"]["formatter"]} in #{srv_name}" do
    package_name node["cb-logstash"]["logging"]["formatter"]
    virtualenv "/opt/cloudbau/#{srv_name}-virtualenv"
    # Override service attribute to be logstash aware.
    node.override[srv_name]["logging.conf"]["formatter"] = "logstasher.LogStashFormatter"
    node.override[srv_name]["logging.conf"]["use"] = true
    node.override[srv_name]["syslog"]["use"] = false
  end.run_action(:install)
end
