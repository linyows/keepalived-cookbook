# Cookbook Name:: keepalived
# Recipe:: vrrp

Array(node['keepalived']['instances']).each do |name, instance|
  instance['states'] ||= {}
  instance['priorities'] ||= {}
  instance['virtual_router_ids'] ||= {}
  defaults = node['keepalived']['instance']

  keepalived_vrrp name do
    action :create

    interface instance['interface']
    virtual_router_id (instance['virtual_router_ids'][node.name] || defaults['virtual_router_id']).to_i
    garp_master_delay (instance['garp_master_delay'] || defaults['garp_master_delay']).to_i
    advert_int (instance['advert_int'] || defaults['advert_int']).to_i
    state (instance['states'][node.name] || defaults['state']).to_sym
    nopreempt if instance['nopreempt']
    priority (instance['priorities'][node.name] || defaults['priority']).to_i
    virtual_ip_addresses instance['virtual_ip_addresses']

    auth_type instance['auth_type'].to_sym if instance['auth_type']
    auth_pass instance['auth_pass'] if instance['auth_pass']
    track_script instance['track_script'] if instance['track_script']
    notify_master interface['notify_master'] if interface['notify_master']
    notify_backup interface['notify_backup'] if interface['notify_backup']
    notify_fault interface['notify_fault'] if interface['notify_fault']
  end
end
