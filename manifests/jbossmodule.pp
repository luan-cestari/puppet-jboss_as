# Sets up a directory under /usr/share/jbossas/modules as a property module
#
# For instance:
#
#   libeap6::propertymodule('com/redhat/services/properties':
#   }
#
# This decleration creates these directories:
# /usr/share/jbossas/modules/com
# /usr/share/jbossas/modules/com/redhat
# /usr/share/jbossas/modules/com/redhat/properties
# /usr/share/jbossas/modules/com/redhat/properties/main
#
# It also installs a module.xml file using property-module.xml.erb as the
# template
#
# All propertyfile declarations require a propertymodule. So, you have
# to declare a libeap6::propertymodule instance to setup the property
# directory structure.
define libeap6::propertymodule {
    include libeap6::pkgs
    include libeap6::variables

    $module_dirs=subdir_list_from_str("${libeap6::variables::eap6_home}/modules","${name}/main")
    $module_dir_list=inline_template('<%=module_dirs.join(\' \')%>')

    exec { "dirs_${name}":
        command  => "mkdir -p -m 0755 ${libeap6::variables::eap6_home}/modules/${name}/main",
    }

    exec { "chown_${name}":
        command => "chown jboss:jboss ${module_dir_list}",
        require => [ User['jboss'], Exec["dirs_${name}"] ],
    }

    file { "${libeap6::variables::eap6_home}/modules/${name}/main/module.xml":
        group   => 'jboss',
        owner   => 'jboss',
        mode    => '0644',
        content => template('libeap6/property-module.xml.erb'),
        require => Exec["chown_${name}"],
    }
}

# Installs a property file as an EAP6 module
#
#  name: Name of the property file (ex. service-address.properties).
#        May contain subdirs.
#  moduledir: Module directory under which to install the file.
#             Leading and trailing '/'s are stripped
#             (ex. com/redhat/services/properties)
#  content : file contents (ex. template('blah.erb'))
#
# This installs the property file under the given directory under main/,
# and installs a module.xml
#
#  You have to instantiate the propertymodule for the module directory in
# the module this is used. That is, you have to have:
#
#     libeap6::propertymodule{ 'somemoduledir':
#     }
#
#
# You can install property files under subdirectories of the property dir.
# You have to make sure all intermediate subdirectories are created using
# file {}. That is, if you have a property file
# /resources/service/someresource.properties, it is your responsibility to
# make sure /usr/share/jbossas/.../main/resources/service directory exists.
define libeap6::propertyfile (
  $moduledir,
  $content) {


  $moduledir_strip_lead = inline_template('<%=moduledir.start_with?(\'/\')?moduledir[1,moduledir.length()-1]:moduledir%>')
  $moduledir_strip = inline_template('<%=moduledir_strip_lead.end_with?(\'/\')?moduledir_strip_lead[0,moduledir_strip_lead.length()-1]:moduledir_strip_lead%>')


  $name_stripped = inline_template('<%= name.start_with?(\'/\')?name[1,name.length()-1]:name%>')

  # Get the directory part of filename, no leading or trailing /
  $subdir = inline_template('<%= name_stripped.rindex(\'/\') == nil ? \'\' : name_stripped[0,name_stripped.rindex(\'/\')] %>')
  # Get the filename
  $fname = inline_template('<%= name_stripped.rindex(\'/\') == nil ? name_stripped : name_stripped[name_stripped.rindex(\'/\')+1,name_stripped.length()]%>')


  if $subdir != '' {
    file { "${libeap6::variables::eap6_home}/modules/${moduledir_strip}/main/${subdir}/${fname}":
      group   => 'jboss',
      owner   => 'jboss',
      mode    => '0644',
      content => $content,
      require => [ File["${libeap6::variables::eap6_home}/modules/${moduledir_strip}/main/${subdir}"], Propertymodule[$moduledir_strip] ],
      notify  => Exec['restart_needed'],
    }
  } else {
    file { "${libeap6::variables::eap6_home}/modules/${moduledir_strip}/main/${fname}":
      group   => 'jboss',
      owner   => 'jboss',
      mode    => '0644',
      content => $content,
      require => [ Propertymodule[$moduledir_strip] ],
      notify  => Exec['restart_needed'],
    }
  }
}
