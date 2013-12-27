# rji-jboss\_as [![Build Status](https://travis-ci.org/rji/puppet-jboss_as.png?branch=master)](https://travis-ci.org/rji/puppet-jboss_as)
A Puppet module to manage the installation, configuration, and application deployments for JBoss Application Server 7. It is compatible with Enterprise Linux and Ubuntu.

  * Project page: <https://github.com/rji/puppet-jboss_as>
  * Puppet Forge: <http://forge.puppetlabs.com/rji/jboss_as>

## Features

  * Install and configure JBoss AS 7 on Enterprise Linux and Ubuntu; this has been tested on CentOS 6 and Ubuntu 12.04.
  * Deploy and undeploy multiple Java application packages, using either hot or cold deployment methods.
  * A starting point for Puppet/ERB templating to suit your environment.

## Getting Started
rji-jboss\_as was developed and tested using Puppet 2.7.x on CentOS 6.4 and Ubuntu 12.04.

  * The node that JBoss AS is being installed on should already have a working Java installation. If not, check out the [puppetlabs-java](https://github.com/puppetlabs/puppetlabs-java) module to manage OpenJDK.
  * Download the [JBoss AS 7.1.1](http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz) tarball from jboss.org and place it in the `files/` directory.
  * A working knowledge of JBoss AS installation, configuration, and application deployments.
  * A healthy background with Puppet/ERB templating. Because JBoss AS is a very powerful application server, it is not realistic to manage _every_ aspect of its configuration here. A certain level of customization is expected for each environment.

## Usage
Basic usage to install and configure JBoss AS, and deploy an archive named `helloworld.war`:

    node 'app1.example.com' {
        include jboss_as
        jboss_as::deploy { 'helloworld.war': }
    }

### Installing and Configuring JBoss AS
To accept the default class parameters in `manifests/init.pp`, you can install and configure JBoss AS simply by including the class for a given node:

    node 'app1.example.com' {
        include jboss_as
    }

Otherwise, you can override the default parameters. All (current) parameters that can be specified are listed in the example below:

    node 'app1.example.com' {
        class { 'jboss_as':
            jboss_dist     => 'jboss-as-7.1.1.Final.tar.gz',
            jboss_user     => 'jboss-as',
            jboss_group    => 'jboss-as',
            jboss_home     => '/usr/share/jboss-as',
            staging_dir    => '/tmp/puppet-staging/jboss_as',
            standalone_tpl => 'jboss_as/standalone.xml.erb'
        }
    }

### Deploying Applications
This module defines a new type, `jboss_as::deploy`. To accept the default parameters in `manifests/deploy.pp`, you can deploy an application by including the type for a given node and specifying the package to deploy. *Note that the package must be located in this module's `files/` directory.*

    node 'app1.example.com' {
        include jboss_as
        jboss_as::deploy { 'helloworld.war': }
    }

You can override the default class parameters on a deployment-by-deployment basis:

    node 'app1.example.com' {
        include jboss_as
        jboss_as::deploy { 'helloworld':
            pkg         => 'helloworld.war',
            is_deployed => true,
            hot_deploy  => false
        }
    }

You can also use the `jboss_as::deploy` class to undeploy applications:

    node 'app1.example.com' {
        include jboss_as
        jboss_as::deploy { 'helloworld.war':
              is_deployed => false
        }
    }

## Tests
The tests for this module were executed against Ruby 1.8.7. To download/install the required gems, run:

    $ bundle install

There are several `rspec-puppet` tests that can be run with:

    $ rake spec

And syntax checking can be performed with:

    $ rake lint

