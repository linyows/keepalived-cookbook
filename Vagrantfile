# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.ssh.max_tries = 10

  config.vm.box = 'Ubuntu_12.04-Chef_11.4.4'
  config.vm.box_url = 'http://goo.gl/np92o'
  config.vm.hostname = 'keepalived'
  config.vm.network :private_network, ip: '192.168.33.33'

  config.vm.provider :virtualbox do |vb, override|
    vb.customize ['modifyvm', :id, '--cpuexecutioncap', '50']
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "keepalived"
    chef.add_recipe "keepalived::vrrp"
    chef.add_recipe "keepalived::virtual_server"
    chef.json = {
      :keepalived => {
        :check_scripts => {
          :unicorn => {
            :script => 'kill -0 unicorn',
            :interval => 2,
            :weight => 2
          }
        },
        :instances => {
          :vi_1 => {
            :virtual_ip_addresses => '192.168.0.1',
            :interface => 'eth0',
            :state => :master,
            :states => {
              'keepalived' => :master,
              'master.domain' => :master,
              'backup.domain' => :backup
            },
            :virtual_router_ids => {
              'keepalived' => 'SERVICE_MASTER',
              'master.domain' => 'SERVICE_MASTER',
              'backup.domain' => 'SERVICE_BACKUP'
            },
            :priorities => {
              'keepalived' => 101,
              'master.domain' => 101,
              'backup.domain' => 100
            },
            :track_script => 'unicorn',
            :nopreempt => false,
            :advert_int => 1,
            :grap_master_delay => 5,
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
    }
  end
end
