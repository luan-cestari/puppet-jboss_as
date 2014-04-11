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
    $standalone_tpl = $jboss_as::params::standalone_tpl,
    $download       = false,
    $username        = undef,
    $password        = undef,
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
    notice("a")
    if ($download) {
      notice("b")
      exec { 'DownloadEAP': 
        command => "curl -L -c cookies.txt -o /tmp/eap.zip 'https://www.redhat.com/wapps/sso/login.html' -H 'Cookie: rh_omni_tc=70160000000H4AjAAK; s_vnum=1398447830558%26vn%3D1; s_fid=23462B5DD35717AF-145059786A1C7770; s_cc=true; s_nr=1395855837745; s_invisit=true; s_sq=redhatglobal%2Credhatcomglobal%3D%2526pid%253Dhttps%25253A%25252F%25252Fwww.redhat.com%25252Fwapps%25252Fsso%25252Flogin.html%25253FloginError%25253Derror_login%252526redirect%25253Dhttps%25253A%25252F%25252Faccess.redhat.com%25252Fjbossnetwork%25252Frestricted%25252FsoftwareDownload.html%25253FsoftwareId%25253D26463%252523error%2526oid%253DLog%252520In%2526oidt%253D3%2526ot%253DSUBMIT' -H 'Origin: https://www.redhat.com' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Accept-Language: en-US,en;q=0.8,en-GB;q=0.6,pt-BR;q=0.4,pt;q=0.2,fr;q=0.2,es-419;q=0.2,es;q=0.2' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: https://www.redhat.com/wapps/sso/login.html?loginError=error_login&redirect=https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=26463' -H 'Connection: keep-alive' --data 'username='$username'&password='$password'&_flowId=legacy-login-flow&redirect=https%3A%2F%2Faccess.redhat.com%2Fjbossnetwork%2Frestricted%2FsoftwareDownload.html%3FsoftwareId%3D26463&failureRedirect=http%3A%2F%2Fwww.redhat.com%2Fwapps%2Fsso%2Flogin.html' --compressed",
        path    => [ '/usr/bin/' ],
      }
    }

    # Proceed with installation and config
    include jboss_as::install, jboss_as::config, jboss_as::service
}
