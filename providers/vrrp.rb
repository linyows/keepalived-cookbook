# Cookbook Name:: keepalived
# Provider:: vrrp

action :create do
  options = %w(
    advert_int
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

  r = template "#{new_resource.name}_vrrp" do
    path "/etc/keepalived/conf.d/#{new_resource.name}_vrrp.conf"
    source "vrrp.conf.erb"
    cookbook "keepalived"
    owner "root"
    group "root"
    mode "0644"
    variables(
      'name' => new_resource.name,
      'interface' => new_resource.interface,
      'virtual_router_id' => new_resource.virtual_router_id,
      'state' => new_resource.state,
      'nopreempt' => new_resource.nopreempt,
      'priority' => new_resource.priority,
      'virtual_ip_addresses' => new_resource.virtual_ip_addresses,
      'options' => options
    )
    notifies :reload, "service[keepalived]", :immediately
  end

  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

