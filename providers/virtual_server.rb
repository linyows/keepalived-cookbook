# Cookbook Name:: keepalived
# Provider:: virtual_server

action :create do
  resource_name = 'virtual_server'
  resource_name += "_group" if new_resource.ip_addresses.count > 1

  file_name = "#{new_resource.name}_#{resource_name}"

  r = template file_name do
    path "/etc/keepalived/conf.d/#{file_name}.conf"
    source "#{resource_name}.conf.erb"
    cookbook 'keepalived'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'name' => new_resource.name,
      'ip_address' => new_resource.ip_addresses.last,
      'ip_addresses' => new_resource.ip_addresses,
      'delay_loop' => new_resource.delay_loop,
      'lvs_sched' => new_resource.lvs_sched,
      'lvs_method' => new_resource.lvs_method,
      'protocol' => new_resource.protocol,
      'real_servers' => new_resource.real_servers,
      'sorry_server' => new_resource.sorry_server,
      'virtual_host' => new_resource.virtual_host
    )
    notifies :reload, 'service[keepalived]'
  end

  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
