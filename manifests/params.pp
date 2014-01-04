# Class jboss_as::params
# Parameters used throughout the module.
#
class jboss_as::params {
  $jboss_user     = 'jboss-as'
  $jboss_group    = 'jboss-as'
  $jboss_dist     = 'jboss-as-7.1.1.Final.tar.gz'
  $jboss_home     = '/usr/share/jboss-as'
  $staging_dir    = '/tmp/puppet-staging/jboss_as'
  $standalone_tpl = 'jboss_as/standalone.xml.erb'

  # Init script template and install commands based on OS
  case $::operatingsystem {
    redhat, centos: {
      $initscript_template    = 'jboss-as-initscript-el.sh.erb'
      $initscript_install_cmd = 'chkconfig --add jboss-as'
    }
    ubuntu: {
      $initscript_template    = 'jboss-as-initscript-ubuntu.sh.erb'
      $initscript_install_cmd = 'update-rc.d jboss-as defaults'
    }
    default: {
      # Note that we should never make it here... if the OS is unsupported,
      # it should have failed in `init.pp`.
      fail("Unsupported operating system ${::operatingsystem}")
    }
  }
}
