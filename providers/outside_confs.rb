# Cookbook Name:: keepalived
# Provider:: outside_confs

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :init do
  converge_by "Run #{new_resource}" do
    directory new_resource.name do
      action :create
      path outside_conf_dir_path
      owner 'root'
      group 'root'
      mode 0775
      not_if "ls #{outside_conf_dir_path}"
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  converge_by "Run #{new_resource}" do
    if outside_conf_file_names
      outside_conf_file_names.map { |file_name|
        file_name unless new_resource.except.include? file_name
      }.compact.each { |file_name|
        file_path = "#{outside_conf_dir_path}/#{file_name}"
        file file_path do
          action :delete
          notifies :restart, 'service[keepalived]'
        end
        Chef::Log.info "delete #{file_path}"
      }
    else
      Chef::Log.info 'unused configs is not there - nothing to do'
    end

    new_resource.updated_by_last_action(true)
  end
end
