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
}
