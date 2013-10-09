# Class: jboss_as::service
# This class ensures the service is enabled and running.
#
class jboss_as::service {

  include jboss_as::config

  service { 'jboss-as':
    ensure     => running,
    enable     => true,
    hasrestart => false,
    require    => File['/etc/jboss-as/jboss-as.conf'],
    subscribe  => File["${jboss_as::jboss_home}/standalone/configuration/standalone.xml"]
  }
}
