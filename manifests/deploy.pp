# Definition: jboss_as::deploy
# Deploys a EAR/WAR application archive to a JBoss application server.
#
define jboss_as::deploy(
  $pkg         = $title,
  $is_deployed = true,
  $hot_deploy  = true
) {
  include jboss_as
  $deploy_dir = "${jboss_as::jboss_home}/standalone/deployments"

  case $is_deployed {
    true:  { $ensure = 'present' }
    false:   { $ensure = 'absent' }
    default: { $ensure = 'present' }
  }

  # Hot deploy allows for packages to be deployed and undeployed on a JBoss AS
  # system without restarting the application server. In certain environments,
  # this can lead to memory leaks, but otherwise its use is acceptable. The
  # default here is to use hot deploy.
  File {
    owner   => $jboss_as::jboss_user,
    group   => $jboss_as::jboss_group,
    mode    => '0664',
    require => Class['jboss_as::install', 'jboss_as::config']
  }

  if ($hot_deploy == true) {
    file { "${deploy_dir}/${pkg}":
      ensure => $ensure,
      source => "puppet:///modules/jboss_as/${pkg}"
    }
  }
  else {
    file { "${deploy_dir}/${pkg}":
      ensure => $ensure,
      source => "puppet:///modules/jboss_as/${pkg}",
      notify => Service['jboss-as']
    }
  }
}
