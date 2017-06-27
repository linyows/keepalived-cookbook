# Cookbook Name:: keepalived
# Resource:: default

actions :enable, :disable
default_action :enable

def initialize(*args)
  super
  @action = :enable
end

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :router_id,
  :name_attribute => true,
  :kind_of => String,
  :default => 'default_router_id'
attribute :notification_emails,
  :kind_of => Array,
  :default => %w(admin@example.com)
attribute :notification_email_from,
  :kind_of => String,
  :default => 'example.com'
attribute :smtp_server,
  :kind_of => String,
  :default => '127.0.0.1'
attribute :smtp_connect_timeout,
  :kind_of => Integer,
  :default => 30
attribute :include_files,
  :kind_of => Array,
  :default => []
attribute :global_defs,
  :kind_of => [TrueClass, FalseClass],
  :default => true
