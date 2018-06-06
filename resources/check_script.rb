# Cookbook Name:: keepalived
# Resource:: check_script

actions :create
default_action :create

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :file_name,
  :kind_of => String
attribute :script,
  :kind_of => String,
  :required => true
attribute :interval,
  :kind_of => Integer,
  :default => 2
attribute :weight,
  :kind_of => Integer
attribute :fall,
  :kind_of => Integer
attribute :rise,
  :kind_of => Integer
