source 'http://rubygems.org'

gem 'rake'
gem 'puppet', '~> 2.7'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 2.7' 
end
