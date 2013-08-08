name 'keepalived'
maintainer 'linyows'
maintainer_email 'linyows@gmail.com'
license 'All rights reserved'
description 'Installs/Configures keepalived'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

%w(centos redhat fedora ubuntu debian).each { |os| supports os }
