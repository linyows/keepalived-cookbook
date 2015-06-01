# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  keepalived = {
    keepalived: {
      notification_emails: 'linyows@gmail.com',
      notification_email_from: 'from@keepaliv.ed',
      smtp_server: '127.0.0.1',
      smtp_connect_timeout: 30,
      router_id: 'keepalived_test',
      vrrp_instances: {
        vi_1: {
          virtual_ip_addresses: '192.168.50.254',
          interface: 'enp0s8',
          state: :master,
          states: {
            'entry1' => :master,
            'entry2' => :backup
          },
          virtual_router_ids: {
            'entry1' => 1,
            'entry2' => 1
          },
          priorities: {
            'entry1' => 101,
            'entry2' => 100
          },
          nopreempt: false,
          advert_int: 1,
          garp_master_delay: 3,
          auth_type: :pass,
          auth_pass: 'secret'
        }
      },
      virtual_servers: {
        http: {
          ip_addresses: '192.168.50.254 80',
          delay_loop: 15,
          lvs_sched: :rr,
          lvs_method: :dr,
          protocol: :tcp,
          real_server: {
            port: 80,
            weight: 1,
            inhibit_on_failure: true,
            tcp_check_port: 80,
            tcp_check_timeout: 30
          },
          real_servers: [
            { ip_address: '192.168.50.101' },
            { ip_address: '192.168.50.102' }
          ]
        }
      }
    }
  }

  def workspace
    if @workspace.nil?
      @workspace = read_workspace_path
      @workspace = create_workspace if @workspace.empty? || !FileTest::exists?(@workspace)
    end
    @workspace
  end

  def read_workspace_path
    `cat .workspace 2>/dev/null`.chomp
  end

  def create_workspace
    workspace = Dir.mktmpdir('keepalived-cookbook')
    `echo -n "#{workspace}" > .workspace`
    workspace
  end

  def sync_workspace
    src = File.expand_path('../', __FILE__)
    dst = File.join(workspace, 'keepalived')
    FileUtils.rm_rf dst
    FileUtils.cp_r src, dst
  end

  Dir.chdir(File.expand_path '../', __FILE__)
  sync_workspace

  config.vm.box = 'linyows/centos-7.1_chef-12.2_puppet-3.7'
  cookbooks_path = [workspace]

  def scripts_for_lvs
    <<-SCRIPTS
      sudo su
      yum -y install tcpdump
      sysctl -w net.ipv4.ip_forward=1
      echo 'net.ipv4.ip_forward = 1' > /usr/lib/sysctl.d/10-ipv4_foward.conf
    SCRIPTS
  end

  def scripts_for_web(hostname)
    vip = '192.168.50.254'
    <<-SCRIPTS
      sudo su
      yum -y install httpd
      echo '#{hostname}' > /var/www/html/index.html
      systemctl start httpd
      systemctl enable httpd
      iptables -t nat -I PREROUTING -d #{vip} -j REDIRECT
      service iptables save
    SCRIPTS
  end

  config.vm.define :lvs1 do |m|
    m.vm.network :private_network, ip: '192.168.50.11'
    m.vm.provision 'shell', inline: scripts_for_lvs
    m.vm.provision :chef_zero do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'keepalived'
      chef.json = keepalived
    end
  end

  config.vm.define :lvs2 do |m|
    m.vm.network :private_network, ip: '192.168.50.12'
    m.vm.provision 'shell', inline: scripts_for_lvs
    m.vm.provision :chef_zero do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'keepalived'
      chef.json = keepalived
    end
  end

  config.vm.define :web1 do |m|
    m.vm.network :private_network, ip: '192.168.50.101'
    m.vm.provision 'shell', inline: scripts_for_web(:web1)
  end

  config.vm.define :web2 do |m|
    m.vm.network :private_network, ip: '192.168.50.102'
    m.vm.provision 'shell', inline: scripts_for_web(:web2)
  end
end
