require 'spec_helper'

describe 'jboss_as' do
  let :facts do
    {
      :operatingsystem => 'CentOS'
    }
  end

  let :params do
    {
      :jboss_dist  => 'jboss-as-7.1.1.Final.tar.gz',
      :jboss_user  => 'jboss-as',
      :jboss_group => 'jboss-as',
      :jboss_home  => '/usr/share/jboss-as',
      :staging_dir => '/tmp/puppet-staging/jboss_as'
    }
  end

  it { should include_class('jboss_as::install') }
  it { should include_class('jboss_as::config') }

  # Init script
  it do
    should contain_file('/etc/init.d/jboss-as')\
      .with_content(/^\s*JBOSS_HOME=\/usr\/share\/jboss-as$/)
  end
  it do
    should contain_file('/etc/init.d/jboss-as').with({
      'ensure' => 'present',
      'mode'   => '0755',
      'owner'  => 'root'
    })
  end

  # Init script configuration file
  it do
    should contain_file('/etc/jboss-as/jboss-as.conf')\
      .with_content(/^JBOSS_USER=jboss-as$/)
  end

  # JBoss AS 'standalone.xml' configuration file
  it do
    should contain_file('/usr/share/jboss-as/standalone/configuration/standalone.xml').with({
      'ensure' => 'present',
      'mode'   => '0644'
    })
  end

  context 'On an unsupported OS' do
    let :facts do
      {
        :operatingsystem => 'foo'
      }
    end

    it do
      expect { should raise_error(Puppet::Error) }
    end
  end
end
