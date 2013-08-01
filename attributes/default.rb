default["cb-logstash"]["openstack"]["services"] = ["nova", "cinder", "quantum", "keystone", "glance"]
default["cb-logstash"]["logging"]["formatter"] = "git+git://github.com/mouadino/logstasher.git"

override['logstash']['elasticsearch_role'] = 'single-controller'
override['logstash']['server']['enable_embedded_es'] = false

override['kibana']['branch'] = "4deca04e2571df3f05e52cb32fcd1cec74f907e1"
override['kibana']['webserver_listen'] = "*"
override['kibana']['webserver'] = "apache"
override['kibana']['webserver_port'] = 8400
