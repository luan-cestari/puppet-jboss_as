# Class: jboss_as::config
# Configures the JBoss AS, some JVM runtime parameters, and add'l modules.
#
class jboss_as::config {

  file { "${jboss_as::jboss_home}/standalone/configuration/standalone.xml":
    ensure  => present,
    owner   => 'root',
    group   => $jboss_as::jboss_group,
    mode    => '0644',
    content => template($jboss_as::standalone_tpl),
    require => Class['jboss_as::install']
  }

  file { '/etc/jboss-as': ensure => directory }

  file { '/etc/jboss-as/jboss-as.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('jboss_as/jboss-as-service.conf.erb'),
    require => File['/etc/jboss-as', '/etc/init.d/jboss-as']
  }

  # Add additional JBoss modules (datastore drivers, etc) below.

}
