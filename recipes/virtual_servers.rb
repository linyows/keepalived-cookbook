# Cookbook Name:: keepalived
# Recipe:: virtual_servers

Array(node['keepalived']['virtual_servers']).each do |name, server|
  if server[:real_server] && server[:real_servers].is_a?(Array)
    rs = server[:real_servers].each_with_object([]) do |real_server, result|
      result << real_server.merge(server[:real_server])
    end
  end

  keepalived_virtual_server name do
    action :create

    ip_addresses Array(server[:ip_addresses])
    delay_loop server[:delay_loop].to_i
    lvs_sched server[:lvs_sched].to_sym
    lvs_method server[:lvs_method].to_sym
    protocol server[:protocol].to_sym
    real_servers rs

    sorry_server server[:sorry_server] if server[:sorry_server]
    virtual_host server[:virtual_host] if server[:virtual_host]
  end
end
