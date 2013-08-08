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
  notifies :start, 'service[keepalived]'
  notifies :reload, 'service[keepalived]'
end
