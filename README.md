Keepalived Cookbook
===================

[![Build Status](https://secure.travis-ci.org/linyows/keepalived-cookbook.png)][travis]

Installs keepalived and generates the configuration file.

Usage
-----

Role based load balancing example:

```ruby
run_list(
  'recipe[keepalived]'
)

override_attributes(
  :keepalived => {
    :instances => {
      :vi_1 => {
        :ip_addresses => '10.0.0.1',
        :interface => 'eth0',
        :states => { 'app001.foo.com' => :backup, 'app002.foo.com' => :backup },
        :virtual_router_ids => { 'app001.foo.com' => 200, 'app002.foo.com' => 200 },
        :priorities => { 'app001.foo.com' => 100, 'app002.foo.com' => 99 },
        :nopreempt => false,
        :advert_int => 1,
        :garp_master_delay => 3,
        :auth_type => :pass,
        :auth_pass => 'secret'
      }
    },
    :virtual_servers => {
      :secure_web => {
        :ip_addresses => '10.0.0.1 443',
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

Requirements
------------

- Chef >= 11.4
- Platform: ubuntu, debian, fedora, centos and redhat

Installation
------------

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks. To install Librarian-Chef:

```ruby
cd chef-repo
gem install librarian
librarian-chef init
```

To reference the Git version:

```log
repo="linyows/keepalived-cookbook"
latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
| ruby -rjson -e '
  j = JSON.parse(STDIN.read);
  puts j.map { |t| t["ref"].split("/").last }.sort.last
')
cat >> Cheffile <<END_OF_CHEFFILE
cookbook 'keepalived', :git => 'git://github.com/$repo.git', :ref => '$latest_release'
END_OF_CHEFFILE
librarian-chef install
```

Resources / Providers
---------------------

- vrrp
- virtual_server
- check_script




License and Author
------------------

MIT License

- [linyows][linyows]

[travis]: http://travis-ci.org/linyows/keepalived-cookbook
[librarian]: https://github.com/applicationsonline/librarian#readme
[linyows]: https://github.com/linyows
