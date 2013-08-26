# Cookbook Name:: keepalived
# Recipe:: default

package 'ipvsadm'
package 'keepalived'

service 'keepalived' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
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
  notifies :restart, 'service[keepalived]'
end

include_recipe 'keepalived::vrrp'
include_recipe 'keepalived::check_script'
include_recipe 'keepalived::virtual_server'
