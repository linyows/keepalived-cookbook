# Cookbook Name:: keepalived
# Provider:: check_script

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :create do
  converge_by "Run #{new_resource}" do
    keepalived_outside_confs "init for #{new_resource.name} check_script" do
      action :init
    end

    file_name = new_resource.file_name || outside_conf_file_name(new_resource.name)

    options = %w(
      weight
      fall
      rise
    ).each_with_object({}) do |attr, result|
      if new_resource.respond_to?(attr) && !new_resource.send(attr.to_sym).nil?
        result[attr] = new_resource.send(attr.to_sym)
      end
    end

    r = template file_name do
      path "#{outside_conf_dir_path}/#{file_name}"
      source 'check_script.conf.erb'
      cookbook 'keepalived'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        'name' => new_resource.name,
        'script' => new_resource.script,
        'interval' => new_resource.interval,
        'options' => options
      )
      notifies :restart, 'service[keepalived]'
    end

    new_resource.updated_by_last_action(r.updated_by_last_action?)
  end
end
