# Cookbook Name:: keepalived
# Recipe:: check_scripts

Array(node['keepalived']['check_scripts']).each do |name, script|
  keepalived_check_script name do
    action :create

    script script[:script] || node['keepalived']['check_script']['script']
    interval script[:interval].to_i || node['keepalived']['check_script']['interval']

    w = (script[:weight].to_i || node['keepalived']['check_script']['weight'])
    f = (script[:fall].to_i || node['keepalived']['check_script']['fall'])
    r = (script[:rise].to_i || node['keepalived']['check_script']['rise'])

    weight w if w
    fall f if f
    rise r if r
  end
end
