# Cookbook Name:: keepalived
# Resource:: vrrp_sync_group

actions :create
default_action :create

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :file_name,
  :kind_of => String
attribute :group,
  :kind_of => Array,
  :required => true

# Optional attributes
attribute :notify_backup,
  :kind_of => String,
  :required => false
attribute :notify_master,
  :kind_of => String,
  :required => false
attribute :notify_fault,
  :kind_of => String,
  :required => false
