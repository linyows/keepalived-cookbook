# Cookbook Name:: keepalived
# Provider:: virtual_server

action :create do
  resource_name = 'virtual_server'
  if new_resource.ip_and_port.is_a?(Array) && new_resource.ip_and_port.count > 1
    resource_name += "_group"
  end

  file_name = "#{new_resource.name}_#{resource_name}"

  r = template "#{file_name}" do
    path "/etc/keepalived/conf.d/#{file_name}.conf"
    source "#{resource_name}.conf.erb"
    cookbook 'keepalived'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'name' => new_resource.name,
      'ip_and_port' => new_resource.ip_and_port,
      'delay_loop' => new_resource.delay_loop,
      'lvs_sched' => new_resource.lvs_sched,
      'lvs_method' => new_resource.lvs_method,
      'protocol' => new_resource.protocol,
      'real_servers' => new_resource.real_servers,
      'sorry_server' => new_resource.sorry_server,
      'virtual_host' => new_resource.virtual_host
    )
    notifies :reload, 'service[keepalived]', :immediately
  end

  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
