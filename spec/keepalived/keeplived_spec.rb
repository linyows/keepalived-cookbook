require 'spec_helper'

describe service('keepalived') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/keepalived/conf.d/vi_1_vrrp.conf') do
  it { should be_file }
  it { should contain 'vrrp_instance VI_1' }
  it { should contain 'interface eth0' }
  it { should contain 'virtual_router_id SERVICE_MASTER' }
  it { should contain 'state MASTER' }
  it { should contain 'priority 100' }
  it { should contain 'nopreempt' }
  it { should contain 'advert_int 1' }
  it { should contain 'auth_type PASS' }
  it { should contain 'auth_pass secret' }
  it { should contain 'virtual_ipaddress' }
  it { should contain '192.168.0.1' }
  it { should contain 'track_script unicorn' }
end

describe file('/etc/keepalived/conf.d/unicorn_check_script.conf') do
  it { should be_file }
  it { should contain 'vrrp_script unicorn' }
  it { should contain 'interval 2' }
  it { should contain 'weight 2' }
end

describe file('/etc/keepalived/conf.d/secure_web_virtual_server.conf') do
  it { should be_file }
  it { should contain 'virtual_server 157.7.100.50 443' }
  it { should contain 'delay_loop 60' }
  it { should contain 'lb_algo rr' }
  it { should contain 'lb_kind DR' }
  it { should contain 'protocol TCP' }
  it { should contain 'real_server 157.7.100.50 443' }
  it { should contain 'real_server 157.7.100.51 443' }
  it { should contain 'real_server 157.7.100.52 443' }
  it { should contain 'real_server 157.7.100.53 443' }
end
