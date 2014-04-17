define jboss_as::jbossmodule (
  $jboss_home,
  $moduledir,
  $owner = 'jboss-as',
  $group = 'jboss-as',
  ){
    # Because variable scope is inconsistent between Puppet 2.7 and 3.x,
    # we need to redefine the JBOSS_HOME variable within this scope.
    # For more info, see http://docs.puppetlabs.com/guides/templating.html
    $template_module_path = $moduledir

    $module_dirs=subdir_list_from_str("${jboss_home}/modules","${moduledir}/main")
    $module_dir_list=inline_template('<%=module_dirs.join(\' \')%>')

    exec { "dirs_${moduledir}":
        command  => "mkdir -p -m 0755 ${jboss_home}/modules/${moduledir}/main",
        path    => ['/usr/bin', '/bin', '/sbin', '/usr/sbin'],
    }->exec { "chown_${moduledir}":
        command => "chown ${owner}:${group} ${module_dir_list}",
        require => [Exec["dirs_${moduledir}"],Class['jboss_as']],
        path    => ['/usr/bin', '/bin', '/sbin', '/usr/sbin'],
    }->file { "${jboss_home}/modules/${moduledir}/main/module.xml":
        group   => $owner,
        owner   => $group,
        mode    => '0644',
        content => template('jboss_as/module.xml.erb'),
        notify  => Service["jboss-as"],
    }
}

