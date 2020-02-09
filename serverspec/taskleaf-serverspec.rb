require 'spec_helper'


#describe package('    '), :if => os[:family] == 'amazon' do

#chown
%w{
  /var
  /var/www
  /var/www/rails
}.each do |f|
  describe file(f) do
    it { should be_owned_by 'itsuki' }
  end
end

#package
%w{
  git
  make
  gcc-c++
  patch
  openssl-devel
  libyaml-devel
  libffi-devel
  libicu-devel
  libxml2
  libxslt
  libxml2-devel
  libxslt-devel
  zlib-devel
  readline-devel
  ImageMagick
  ImageMagick-devel
  epel-release
}.each do |pkg|
    describe package(pkg) do
    it { should be_installed }
  end
end

#ruby
describe command('ruby -v') do
  its(:stdout) { should match /ruby 2\.5\.1/ }
end

#node.js
describe package('nodejs') do
  it { should be_installed }
end

#yarn
describe command('yarn -v') do
  its(:stdout) { should match /1\.21\.1/ }
end

#rails
describe package('rails') do
  it { should be_installed.by('gem').with_version('5.2.4.1') }
end

#unicorn
describe file('/var/www/rails/taskleaf/taskleaf/Gemfile') do
  it { should contain('unicorn') }
end

describe command('ps aux | grep unicorn') do
  its(:stdout) { should match /master/ }
end

#nginx
describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end


#mysql
describe command('mysqld --version') do
  its(:stdout) { should match /mysqld.*5\.7\.2./ }
end

describe service('mysqld') do
  it { should be_enabled   }
  it { should be_running   }
end

describe 'MySQL config parameters' do
  context mysql_config('innodb-buffer-pool-size') do
    its(:value) { should > 100000000 }
  end

  context mysql_config('socket') do
    its(:value) { should eq '/var/lib/mysql/mysql.sock' }
  end
end


#port
%w{80 22}.each do |f|
  describe port(f) do
    it { should be_listening.with('tcp') }
  end
end


#ELB
#url check return 200 ok
describe command('curl http://elb-raise-560206018.ap-northeast-1.elb.amazonaws.com/login -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end