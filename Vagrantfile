# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.ssh.max_tries = 10
  config.vm.box = 'Ubuntu_12.04-Chef_11.4.4'
  config.vm.box_url = 'http://goo.gl/np92o'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '384']
  end

  keepalived = {
    :keepalived => {
      :notification_emails => 'linyows@gmail.com',
      :notification_email_from => 'from@keepaliv.ed',
      :smtp_server => '127.0.0.1',
      :smtp_connect_timeout => 30,
      :router_id => 'keepalived_test',
      :vrrp_instances => {
        :vi_1 => {
          :virtual_ip_addresses => '127.0.0.1',
          :interface => 'eth0',
          :state => :master,
          :states => {
            'entry1' => :master,
            'entry2' => :backup
          },
          :virtual_router_ids => {
            'entry1' => 1,
            'entry2' => 1
          },
          :priorities => {
            'entry1' => 101,
            'entry2' => 100
          },
          :nopreempt => false,
          :advert_int => 1,
          :garp_master_delay => 3,
          :auth_type => :pass,
          :auth_pass => 'secret'
        }
      },
      :virtual_servers => {
        :http => {
          :ip_and_port => '127.0.0.1 8000',
          :delay_loop => 15,
          :lvs_sched => :rr,
          :lvs_method => :dr,
          :protocol => :tcp,
          :real_server => {
            :port => 80,
            :weight => 0,
            :inhibit_on_failure => true,
            :tcp_check_port => 80,
            :tcp_check_timeout => 30
          },
          :real_servers => [
            { :ip_address => '192.168.50.1' },
            { :ip_address => '192.168.50.2' }
          ]
        }
      }
    }
  }

  cookbooks_path = %w(cookbooks)

  config.vm.define :entry1 do |entry1|
    entry1.vm.hostname = 'entry1'
    entry1.vm.network :private_network, ip: '192.168.50.1'
    entry1.vm.network :forwarded_port, host: 8001, guest: 8000
    entry1.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'keepalived'
      chef.json = keepalived
    end
  end

  config.vm.define :entry2 do |entry2|
    entry2.vm.hostname = 'entry2'
    entry2.vm.network :private_network, ip: '192.168.50.2'
    entry2.vm.network :forwarded_port, host: 8002, guest: 8000
    entry2.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'keepalived'
      chef.json = keepalived
    end
  end
end
