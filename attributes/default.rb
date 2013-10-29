default["cb-logstash"]["openstack"]["services"] = ["nova", "cinder", "neutron", "keystone", "glance"]

normal['logstash']['server']['version'] = '1.2.0'
normal['logstash']['agent']['version'] = '1.2.0'

override['logstash']['elasticsearch_role'] = 'single-controller'
override['logstash']['server']['enable_embedded_es'] = false

override['kibana']['branch'] = "eb25ce5f7e90a3f11b2a56eb43ac9ad15a34c40c"
override['kibana']['webserver_listen'] = "*"
override['kibana']['webserver'] = "apache"
override['kibana']['webserver_port'] = 8400

default['cb-logstash']['kibana']['user'] = 'cloudadmin'
default['cb-logstash']['kibana']['password'] = nil # override me
