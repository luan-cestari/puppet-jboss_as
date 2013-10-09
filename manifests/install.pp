# Class: jboss_as::install
# This class is responsible for deploying the JBoss AS tarball and installing it
# and its service. It is broken into three main parts:
#
#   1. Create the user that JBoss AS will run as
#   2. Copy the JBoss AS tarball from the Puppet master and extract it on the
#      node.
#   3. Install the init script to /etc/init.d and add the service to chkconfig.
#
class jboss_as::install {

  # Create the user that JBoss AS will run as
  user { $jboss_as::jboss_user:
    ensure     => present,
    shell      => '/bin/bash',
    membership => 'minimum',
    managehome => true,
  }

  # As of Puppet 2.7, we can't manage parent dirs. Since we have no way of
  # knowing what directory the user chose for staging, or how deep it is,
  # we have this ugly hack.
  exec { 'create_staging_dir':
    command => "/bin/mkdir -p ${jboss_as::staging_dir}",
    unless  => "/usr/bin/test -d ${jboss_as::staging_dir}"
  }

  file { $jboss_as::jboss_home: ensure => directory }

  # Download the distribution tarball from the Puppet Master
  # and extract to $JBOSS_HOME
  file { "${jboss_as::staging_dir}/${jboss_as::jboss_dist}":
    ensure  => file,
    source  => "puppet:///modules/jboss_as/${jboss_as::jboss_dist}"
  }

  exec { 'extract_and_set_permissions':
    path    => ['/usr/bin', '/bin'],
    command => "tar zxf ${jboss_as::staging_dir}/${jboss_as::jboss_dist} \
                --strip-components=1 -C ${jboss_as::jboss_home} && \
                chown -R ${jboss_as::jboss_user}:${jboss_as::jboss_group} \
                ${jboss_as::jboss_home}",
    unless  => "test -d ${jboss_as::jboss_home}/standalone",
    require => File["${jboss_as::staging_dir}/${jboss_as::jboss_dist}",
                      $jboss_as::jboss_home]
  }

  # Install the init scripts and the service to chkconfig / rc.d
  case $::operatingsystem {
    redhat, centos: {
      $initscript_template = 'jboss-as-initscript-el.sh.erb'
      $exec_cmd            = 'chkconfig --add jboss-as'
    }
    ubuntu: {
      $initscript_template = 'jboss-as-initscript-ubuntu.sh.erb'
      $exec_cmd            = 'update-rc.d jboss-as defaults'
    }
    default: {
      # Note that we should never make it here... if the OS is unsupported,
      # it should have failed in `init.pp`.
      fail("Unsupported operating system ${::operatingsystem}")
    }
  }

  # Because variable scope is inconsistent between Puppet 2.7 and 3.x,
  # we need to redefine the JBOSS_HOME variable within this scope.
  # For more info, see http://docs.puppetlabs.com/guides/templating.html
  $this_jboss_home = $jboss_as::jboss_home

  file { '/etc/init.d/jboss-as':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("jboss_as/${initscript_template}")
  }

  exec { 'install_service':
    path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
    command => $exec_cmd,
    require => File['/etc/init.d/jboss-as'],
    unless  => 'test -f /etc/init.d/jboss-as'
  }
}
