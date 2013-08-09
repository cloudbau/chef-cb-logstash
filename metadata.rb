name             'cb-logstash'
maintainer       'Cloudbau GmbH'
maintainer_email 'm.benchchaoui@cloudbau.de'
license          'All rights reserved'
description      'Installs/Configures logstash'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "logstash", "<= 0.6.1"
depends "kibana"
depends "elasticsearch"

