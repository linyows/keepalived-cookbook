# Cookbook Name:: keepalived
# Recipe:: check_scripts

Array(node[:keepalived][:check_scripts]).each do |name, script|
  keepalived_check_script name do
    action :create

    script script[:script] || node[:keepalived][:check_script][:script]
    interval script[:interval].to_i || node[:keepalived][:check_script][:interval]
    weight script[:weight].to_i || node[:keepalived][:check_script][:weight]
  end
end
