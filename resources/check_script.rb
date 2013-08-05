# Cookbook Name:: keepalived
# Resource:: check_script

actions :create
default_action :create

def initialize(*args)
  super
  @action = :create
end

attribute :script,
  :kind_of => String,
  :required => true
attribute :interval,
  :kind_of => Integer,
  :default => 2
attribute :weight,
  :kind_of => Integer,
  :default => 2
