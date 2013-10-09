require 'spec_helper'

describe 'jboss_as::deploy' do
  let(:title) { 'jboss-as-helloworld.war' }
  let(:facts) { {:operatingsystem => 'CentOS'} }

  it { should include_class('jboss_as::install') }
  it { should include_class('jboss_as::config') }

  it do 
    should contain_file('/usr/share/jboss-as/standalone/deployments/jboss-as-helloworld.war').with({
      'ensure' => 'present',
      'owner'  => 'jboss-as',
      'group'  => 'jboss-as',
      'mode'   => '0664',
    })
  end
end
