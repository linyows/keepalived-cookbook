name             'keepalived'
maintainer       'linyows'
maintainer_email 'linyows@gmail.com'
license          'MIT'
description      'Installs/Configures keepalived'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.2'

recipe 'keepalived', 'Installs and configures keepalived'

%w(centos redhat fedora ubuntu debian).each { |os| supports os }
