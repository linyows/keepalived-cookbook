Keepalived Cookbook
===================

Installs keepalived and generates the configuration file.

Usage
-----

Example:

```ruby
override_attributes(
  :keepalived => {
    :check_scripts => {
      :unicorn => {
        :script => 'kill -0 `cat /var/www/service/tmp/pids/unicorn.pid`',
        :interval => 2,
        :weight => 2
      }
    },
    :instances => {
      :vi_1 => {
        :ip_addresses => '192.168.0.1',
        :interface => 'eth0',
        :states => {
          'master.domain' => :master,
          'backup.domain' => :backup
        },
        :virtual_router_ids => {
          'master.domain' => 'SERVICE_MASTER',
          'backup.domain' => 'SERVICE_BACKUP'
        },
        :priorities => {
          'master.domain' => 101,
          'backup.domain' => 100
        },
        :track_script => 'unicorn',
        :nopreempt => false,
        :advert_int => 1,
        :auth_type => :pass,
        :auth_pass => 'secret'
      }
    },
    :virtual_servers => {
      :secure_web => {
        :ip_and_port => '157.7.100.50 443',
        :delay_loop => 60,
        :lvs_sched => :rr,
        :lvs_method => :dr,
        :protocol => :tcp,
        :real_server_generics => {
          :port => 443,
          :weight => 0,
          :inhibit_on_failure => true,
          :tcp_check_port => 443,
          :tcp_check_timeout => 30
        },
        :real_servers => [
          { :ip_address => '157.7.100.50' },
          { :ip_address => '157.7.100.51' },
          { :ip_address => '157.7.100.52' },
          { :ip_address => '157.7.100.53' }
        ]
      },
      :cache => {
        :ip_and_port => '172.17.4.235 11211',
        :delay_loop => 10,
        :lvs_sched => :rr,
        :lvs_method => :dr,
        :protocol => :tcp,
        :real_server_generics => {
          :port => 11211,
          :weight => 0,
          :inhibit_on_failure => true,
          :tcp_check_port => 11211,
          :tcp_check_timeout => 30
        },
        :real_servers => [
          { :ip_address => '172.17.4.235' },
          { :ip_address => '172.17.4.236' }
        ]
      }
    }
  }
)
```

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
