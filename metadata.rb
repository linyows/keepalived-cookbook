name             'keepalived'
maintainer       'linyows'
maintainer_email 'linyows@gmail.com'
license          'MIT'
description      'Installs/Configures keepalived'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.0'
chef_version '>= 12.5' if respond_to?(:chef_version)

recipe 'keepalived', 'Installs and configures keepalived'
recipe 'keepalived::disabled', 'disable keepalived'

%w(centos redhat fedora ubuntu debian).each { |os| supports os }

source_url 'https://github.com/linyows/keepalived-cookbook'
issues_url 'https://github.com/linyows/keepalived-cookbook/issues'
