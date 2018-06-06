# Cookbook Name:: keepalived
# Provider:: default

include Chef::Mixin::Keepalived

def whyrun_supported?
  true
end

action :enable do
  converge_by "Run #{new_resource}" do
    package 'ipvsadm'
    package 'keepalived'

    service 'keepalived' do
      supports :status => true, :restart => true, :reload => true
      action [:enable, :start]
    end

    template 'keepalived.conf' do
      path conf_path
      source 'keepalived.conf.erb'
      cookbook 'keepalived'
      owner 'root'
      group 'root'
      mode 0644
      variables(
        'name' => new_resource.name,
        'global_defs' => new_resource.global_defs,
        'notification_emails' => new_resource.notification_emails,
        'notification_email_from' => new_resource.notification_email_from,
        'smtp_server' => new_resource.smtp_server,
        'smtp_connect_timeout' => new_resource.smtp_connect_timeout,
        'router_id' => new_resource.router_id,
        'include_files' => new_resource.include_files
      )
      notifies :restart, 'service[keepalived]'
    end
  end
end

action :disable do
  converge_by "Run #{new_resource}" do
    package 'keepalived'

    service 'keepalived' do
      supports :status => true, :start => true, :stop => true, :restart => true
      action [:disable, :stop]
    end
  end
end
