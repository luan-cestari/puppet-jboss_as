define jboss_as::jbossmodulefile (
  $jboss_home,
  $moduledir,
  $configuration_file,
  $owner = 'jboss_as',
  $group = 'jboss_as',
  $content,
  ){

  $moduledir_strip_lead = inline_template('<%=moduledir.start_with?(\'/\')?moduledir[1,moduledir.length()-1]:moduledir%>')
  $moduledir_strip = inline_template('<%=moduledir_strip_lead.end_with?(\'/\')?moduledir_strip_lead[0,moduledir_strip_lead.length()-1]:moduledir_strip_lead%>')


  $configuration_file_stripped = inline_template('<%= configuration_file.start_with?(\'/\')?configuration_file[1,configuration_file.length()-1]:configuration_file%>')

  # Get the directory part of configuration_file, no leading or trailing /
  $subdir = inline_template('<%= configuration_file_stripped.rindex(\'/\') == nil ? \'\' : configuration_file_stripped[0,configuration_file_stripped.rindex(\'/\')] %>')
  # Get the configuration_file
  $fconfiguration_file = inline_template('<%= configuration_file_stripped.rindex(\'/\') == nil ? configuration_file_stripped : configuration_file_stripped[configuration_file_stripped.rindex(\'/\')+1,configuration_file_stripped.length()]%>')


  if $subdir != '' {
    file { "${jboss_home}/modules/${moduledir_strip}/main/${subdir}/${fconfiguration_file}":
      group   => $group,
      owner   => $owner,
      mode    => '0644',
      content => $content,
      notify  => Service["jboss-as"],
    }
  } else {
    file { "${jboss_home}/modules/${moduledir_strip}/main/${fconfiguration_file}":
      group   => $group,
      owner   => $owner,
      mode    => '0644',
      content => $content,
      notify  => Service["jboss-as"],
    }
  }

}
