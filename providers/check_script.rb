# Cookbook Name:: keepalived
# Provider:: check_script

action :create do
  r = template new_resource.name do
    path "/etc/keepalived/conf.d/#{new_resource.name}_check_script.conf"
    source 'check_script.conf.erb'
    cookbook 'keepalived'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'name' => new_resource.name,
      'script' => new_resource.script,
      'interval' => new_resource.interval,
      'weight' => new_resource.weight
    )
    notifies :restart, 'service[keepalived]'
  end

  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
