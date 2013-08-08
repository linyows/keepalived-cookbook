# Cookbook Name:: keepalived
# Attributes:: default

default['keepalived']['global']['notification_emails'] = 'admin@example.com'
default['keepalived']['global']['notification_email_from'] = "keepalived@#{node['domain'] || 'example.com'}"
default['keepalived']['global']['smtp_server'] = '127.0.0.1'
default['keepalived']['global']['smtp_connect_timeout'] = 30
default['keepalived']['global']['router_id'] = 'DEFAULT_ROUT_ID'
default['keepalived']['global']['router_ids'] = {}

default['keepalived']['check_scripts'] = {}

default['keepalived']['instance']['state'] = :master
default['keepalived']['instance']['priority'] = 100
default['keepalived']['instance']['virtual_router_id'] = 1
default['keepalived']['instance']['garp_master_delay'] = 5
default['keepalived']['instance']['auth_type'] = nil
default['keepalived']['instance']['auth_pass'] = nil
default['keepalived']['instance']['track_script'] = nil
default['keepalived']['nterface']['notify_master'] = nil
default['keepalived']['nterface']['notify_backup'] = nil
default['keepalived']['nterface']['notify_fault'] = nil
default['keepalived']['instances'] = {}

default['keepalived']['virtual_server']['delay_loop'] = 5
default['keepalived']['virtual_server']['lvs_sched'] = :lc
default['keepalived']['virtual_server']['lvs_method'] = :dr
default['keepalived']['virtual_server']['protocol'] = :tcp
default['keepalived']['virtual_servers'] = {}
