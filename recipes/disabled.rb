# Cookbook Name:: keepalived
# Recipe:: disabled

package 'keepalived'

service 'keepalived' do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [:disable, :stop]
end
