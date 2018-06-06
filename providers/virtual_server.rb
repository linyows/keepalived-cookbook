# Cookbook Name:: keepalived
# Provider:: virtual_server

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :create do
  converge_by "Run #{new_resource}" do
    keepalived_outside_confs "init for #{new_resource.name} virtual_server" do
      action :init
    end

    resource_name = 'virtual_server'
    resource_name += '_group' if new_resource.ip_addresses.count > 1
    file_name = new_resource.file_name || outside_conf_file_name(new_resource.name)

    template file_name do
      path "#{outside_conf_dir_path}/#{file_name}"
      source "#{resource_name}.conf.erb"
      cookbook 'keepalived'
      owner 'root'
      group 'root'
      mode 0644
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
      notifies :restart, 'service[keepalived]'
    end
  end
end
