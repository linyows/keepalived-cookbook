# Cookbook Name:: keepalived
# Resource:: virtual_server

actions :create
default_action :create

def initialize(*args)
  super
  @action = :create
end

attribute :ip_addresses,
  :kind_of => [Array, String],
  :required => true
attribute :delay_loop,
  :kind_of => Integer,
  :default => 15
attribute :lvs_sched,
  :kind_of => Symbol,
  :equal_to => [:rr, :wrr, :lc, :wlc, :sh, :dh, :lblc],
  :default => :rr
attribute :lvs_method,
  :kind_of => Symbol,
  :equal_to => [:nat, :dr, :tun],
  :default => :nat
attribute :protocol,
  :kind_of => Symbol,
  :equal_to => [:tcp, :udp],
  :default => :tcp
attribute :real_servers,
  :kind_of => Array,
  :required => true

# Optional attributes
attribute :sorry_server,
  :kind_of => String,
  :required => false
attribute :virtual_host,
  :kind_of => String,
  :required => false
