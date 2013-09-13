node.normal['kibana']['es_server'] = node.normal['elasticsearch']['network.bind_host'] = get_ip_for_net('management')
#node.normal['elasticsearch']['network.publish_host'] = node[:ipaddress] # TODO figure this out (problem?)

include_recipe 'elasticsearch::default'
include_recipe 'logstash::server'
