cb-logstash Cookbook
=================

Cloudbau wrapper cookbook for logstash + kibana installation.


Requirements
------------

Attributes
----------
#### logstash::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cb-logstash']['services']</tt></td>
    <td>List</td>
    <td>All openstack services that should be configured to use logstash.</td>
    <td><tt>nova</tt></td>
  </tr>
  <tr>
    <td><tt>['cb-logstash']['logging']['formatter']</tt></td>
    <td>String</td>
    <td>Python package that should contain a logging formatter to use with openstack services</td>
    <td><tt>git://github.com/mouadino/logstasher.git</tt></td>
  </tr>
</table>

Usage
-----
#### logstash::default

Just include `logstash` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[logstash]"
  ]
}
```


License and Authors
-------------------
Authors: Cloudbau.de GmbH
