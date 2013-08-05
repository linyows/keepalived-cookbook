# Cookbook Name:: keepalived
# Resource:: vrrp

actions :create
default_action :create

def initialize(*args)
  super
  @action = :create
end

attribute :interface,
  :kind_of => String,
  :required => true
attribute :virtual_router_id,
  :kind_of => String,
  :default => 'SERVICE_MASTER'
attribute :state,
  :kind_of => Symbol,
  :equal_to => [:master, :backup],
  :default => :backup
attribute :nopreempt,
  :kind_of => [TrueClass, FalseClass],
  :default => false
attribute :priority,
  :kind_of => Integer,
  :default => 100
attribute :virtual_ip_addresses,
  :kind_of => [String, Array],
  :required => true

# Optional attributes
attribute :advert_int,
  :kind_of => Integer,
  :required => false
attribute :auth_type,
  :kind_of => Symbol,
  :equal_to => [:pass, :ah],
  :required => false
attribute :auth_pass,
  :kind_of => String,
  :required => false
attribute :track_script,
  :kind_of => String,
  :required => false
attribute :notify_master,
  :kind_of => String,
  :required => false
attribute :notify_backup,
  :kind_of => String,
  :required => false
attribute :notify_fault,
  :kind_of => String,
  :required => false
