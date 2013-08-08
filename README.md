Keepalived Cookbook
===================

Installs keepalived and generates the configuration file.

Usage
-----

Role based Example:

```ruby
run_list(
  'recipe[keepalived]',
  'recipe[keepalived::vrrp]',
  'recipe[keepalived::virtual_server]'
)

override_attributes(
  :keepalived => {
    :instances => {
      :vi_1 => {
        :ip_addresses => '192.168.0.1',
        :interface => 'eth0',
        :states => { 'master.domain' => :master, 'backup.domain' => :backup },
        :virtual_router_ids => { 'master.domain' => 1, 'backup.domain' => 2 },
        :priorities => { 'master.domain' => 101, 'backup.domain' => 100 },
        :nopreempt => false,
        :advert_int => 1,
        :garp_master_delay => 3,
        :auth_type => :pass,
        :auth_pass => 'secret',
        :track_script => %w(haproxy https_port)
      }
    },
    :check_script => {
      :haproxy => { :script => 'killall -0 haproxy', :interval => 2 },
      :https_port => { :script => '</dev/tcp/127.0.0.1/443', :interval => 1, :weight => -2 }
    },
    :virtual_servers => {
      :secure_web => {
        :ip_addresses => '157.7.100.50 443',
        :delay_loop => 10,
        :lvs_sched => :rr,
        :lvs_method => :dr,
        :protocol => :tcp,
        :real_server_generics => {
          :port => 443, :weight => 0, :inhibit_on_failure => true,
          :tcp_check_port => 443, :tcp_check_timeout => 30
        },
        :real_servers => [
          { :ip_address => '157.7.100.50' }, { :ip_address => '157.7.100.51' },
          { :ip_address => '157.7.100.52' }, { :ip_address => '157.7.100.53' }
        ]
      }
    }
  }
)
```

Resources / Providers
---------------------

- vrrp
- virtual_server
- check_script


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Authors and Contributors
------------------------

- [linyows](https://github.com/linyows)

License
-------

MIT
