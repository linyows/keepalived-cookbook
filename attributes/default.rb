# Cookbook Name:: keepalived
# Attributes:: default

default['keepalived']['router_id'] = 'default_router_id'
default['keepalived']['notification_emails'] = 'admin@example.com'
default['keepalived']['notification_email_from'] = "keepalived@#{node['domain'] || 'example.com'}"
default['keepalived']['smtp_server'] = '127.0.0.1'
default['keepalived']['smtp_connect_timeout'] = 30
default['keepalived']['global_defs'] = true
default['keepalived']['include_files'] = []

default['keepalived']['check_scripts'] = {}
default['keepalived']['vrrp_instances'] = {}
default['keepalived']['virtual_servers'] = {}

# defaults attributes
default['keepalived']['check_script']['script'] = ''
default['keepalived']['check_script']['interval'] = 2
default['keepalived']['check_script']['weight'] = nil
default['keepalived']['check_script']['fall'] = nil
default['keepalived']['check_script']['rise'] = nil

default['keepalived']['vrrp_instance']['state'] = :master
default['keepalived']['vrrp_instance']['priority'] = 100
default['keepalived']['vrrp_instance']['virtual_router_id'] = 1
default['keepalived']['vrrp_instance']['garp_master_delay'] = 5
default['keepalived']['vrrp_instance']['auth_type'] = nil
default['keepalived']['vrrp_instance']['auth_pass'] = nil
default['keepalived']['vrrp_instance']['track_script'] = []
default['keepalived']['vrrp_instance']['notify_master'] = nil
default['keepalived']['vrrp_instance']['notify_backup'] = nil
default['keepalived']['vrrp_instance']['notify_fault'] = nil

default['keepalived']['virtual_server']['delay_loop'] = 5
default['keepalived']['virtual_server']['lvs_sched'] = :lc
default['keepalived']['virtual_server']['lvs_method'] = :dr
default['keepalived']['virtual_server']['protocol'] = :tcp
