# Cookbook Name:: keepalived
# Provider:: vrrp_sync_group

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :create do
  converge_by "Run #{new_resource}" do
    keepalived_outside_confs "init for #{new_resource.name} vrrp_sync_group" do
      action :init
    end

    options = %w(
      notify_backup
      notify_fault
      notify_master
    ).each_with_object({}) do |attr, result|
      if new_resource.respond_to?(attr) && !new_resource.send(attr.to_sym).nil?
        result[attr] = new_resource.send(attr.to_sym)
      end
    end

    file_name = new_resource.file_name || outside_conf_file_name(new_resource.name)

    template file_name do
      path "#{outside_conf_dir_path}/#{file_name}"
      source 'vrrp_sync_group.conf.erb'
      cookbook 'keepalived'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        'name' => new_resource.name,
        'group' => new_resource.group,
        'options' => options
      )
      notifies :restart, 'service[keepalived]'
    end
  end
end
