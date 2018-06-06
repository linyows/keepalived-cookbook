# Cookbook Name:: keepalived
# Provider:: vrrp_instance

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :create do
  converge_by "Run #{new_resource}" do
    keepalived_outside_confs "init for #{new_resource.name} vrrp_instance" do
      action :init
    end

    options = %w(
      auth_type
      auth_pass
      track_script
      notify_master
      notify_backup
      notify_fault
    ).each_with_object({}) do |attr, result|
      if new_resource.respond_to?(attr) && !new_resource.send(attr.to_sym).nil?
        result[attr] = new_resource.send(attr.to_sym)
      end
    end

    file_name = new_resource.file_name || outside_conf_file_name(new_resource.name)

    template file_name do
      path "#{outside_conf_dir_path}/#{file_name}"
      source 'vrrp_instance.conf.erb'
      cookbook 'keepalived'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        'name' => new_resource.name,
        'interface' => new_resource.interface,
        'virtual_router_id' => new_resource.virtual_router_id,
        'advert_int' => new_resource.advert_int,
        'state' => new_resource.state,
        'nopreempt' => new_resource.nopreempt,
        'garp_master_delay' => new_resource.garp_master_delay,
        'priority' => new_resource.priority,
        'virtual_ip_addresses' => new_resource.virtual_ip_addresses,
        'options' => options
      )
      notifies :restart, 'service[keepalived]'
    end
  end
end
