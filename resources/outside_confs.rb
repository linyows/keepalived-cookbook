# Cookbook Name:: keepalived
# Resource:: outside_confs

actions :init, :delete
default_action :init

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :except,
  :kind_of => [Array, String]
