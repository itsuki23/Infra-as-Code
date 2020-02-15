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

