# Cookbook Name:: keepalived
# Recipe:: default

files = Array(node['keepalived']['check_scripts']).map { |k,v|
  Chef::Keepalived.outside_conf_file_name(:check_script, k)
} + Array(node['keepalived']['vrrp_instances']).map { |k,v|
  Chef::Keepalived.outside_conf_file_name(:vrrp_instance, k)
} + Array(node['keepalived']['virtual_servers']).map { |k,v|
  Chef::Keepalived.outside_conf_file_name(:virtual_server, k)
}

files << node['keepalived']['include_files']

keepalived node['keepalived']['router_id'] do
  action :enable
  global_defs node['keepalived']['global_defs']
  router_id node['keepalived']['router_id']
  notification_emails Array(node['keepalived']['notification_emails'])
  notification_email_from node['keepalived']['notification_email_from']
  smtp_server node['keepalived']['smtp_server']
  smtp_connect_timeout node['keepalived']['smtp_connect_timeout']
  include_files files.flatten.uniq
end

# nothing to do if attributes nothing set
include_recipe 'keepalived::vrrp_instances'
include_recipe 'keepalived::check_scripts'
include_recipe 'keepalived::virtual_servers'

keepalived_outside_confs 'delete unused configs' do
  action :delete
  except files
end
