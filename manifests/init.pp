# rji-jboss_as
# The rji-jboss_as Puppet module manages the installation, configuration, and
# application deployments for JBoss Application Server 7.
#
#   * Puppet Forge: http://forge.puppetlabs.com/rji/jboss_as
#   * Project page: https://github.com/rji/puppet-jboss_as
#
#
# Class: jboss_as
# This class is responsible for installing and configuring the JBoss Application
# Server. Application deployments can then be managed using `jboss_as::deploy`.
#
class jboss_as (
    $jboss_user     = $jboss_as::params::jboss_user,
    $jboss_group    = $jboss_as::params::jboss_group,
    $jboss_dist     = $jboss_as::params::jboss_dist,
    $jboss_home     = $jboss_as::params::jboss_home,
    $staging_dir    = $jboss_as::params::staging_dir,
    $standalone_tpl = $jboss_as::params::standalone_tpl
) inherits jboss_as::params {
    # Ensure we're on a supported OS
    case $::operatingsystem {
        redhat, centos: { $supported = true }
        ubuntu:         { $supported = true }
        default:        { $supported = false }
    }

    if ($supported != true) {
        fail("Sorry, ${::operatingsystem} is not currently supported.")
    }

    # Check to see that a working Java install exists and is available in $PATH
    # Note that this module doesn't manage Java installations. If you need to
    # manage Java, try <https://github.com/puppetlabs/puppetlabs-java>
    exec { 'check-java':
      path    => $::path,
      command => 'java -version',
      unless  => 'java -version'
    }

    # Proceed with installation and config
    include jboss_as::install, jboss_as::config, jboss_as::service
}
