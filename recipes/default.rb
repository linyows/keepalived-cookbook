# Cookbook Name:: keepalived
# Recipe:: default

package 'ipvsadm'
package 'keepalived'

service 'keepalived' do
  supports :restart => true, :status => false
  action :enable
end

directory '/etc/keepalived/conf.d' do
  action :create
  owner 'root'
  group 'root'
  mode '0775'
end

template 'keepalived.conf' do
  path '/etc/keepalived/keepalived.conf'
  source 'keepalived.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :start, 'service[keepalived]', :immediately
  notifies :reload, 'service[keepalived]', :immediately
end

node['keepalived']['check_scripts'].each do |name, script|
  keepalived_check_script name do
    action :create

    script script['script']
    interval script['interval'].to_i
    weight script['weight'].to_i
  end
end

node['keepalived']['instances'].each do |name, instance|
  instance['states'] ||= {}
  instance['priorities'] ||= {}
  instance['virtual_router_ids'] ||= {}
  defaults = node['keepalived']['instance_defaults']

  keepalived_vrrp name do
    action :create

    interface instance['interface']
    virtual_router_id (instance['virtual_router_ids'][node.name] || defaults['virtual_router_id'])
    state (instance['states'][node.name] || defaults['state']).to_sym
    nopreempt if instance['nopreempt']
    priority (instance['priorities'][node.name] || defaults['priority']).to_i
    virtual_ip_addresses instance['virtual_ip_addresses']

    advert_int instance['advert_int'].to_i if instance['advert_int']
    auth_type instance['auth_type'].to_sym if instance['auth_type']
    auth_pass instance['auth_pass'] if instance['auth_pass']
    track_script instance['track_script'] if instance['track_script']
    notify_master interface['notify_master'] if interface['notify_master']
    notify_backup interface['notify_backup'] if interface['notify_backup']
    notify_fault interface['notify_fault'] if interface['notify_fault']
  end
end

node['keepalived']['virtual_servers'].each do |name, server|

  if server['real_server_generics'] && server['real_servers'].is_a?(Array)
    rs = server['real_servers'].each_with_object([]) do |real_server, result|
      result << real_server.merge(server['real_server_generics'])
    end
  end

  keepalived_virtual_server name do
    action :create

    ip_and_port server['ip_and_port']
    delay_loop server['delay_loop'].to_i
    lvs_sched server['lvs_sched'].to_sym
    lvs_method server['lvs_method'].to_sym
    protocol server['protocol'].to_sym
    real_servers rs

    sorry_server server['sorry_server'] if server['sorry_server']
    virtual_host server['virtual_host'] if server['virtual_host']
  end
end
