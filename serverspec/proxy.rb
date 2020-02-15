require 'spec_helper'


#describe package('    '), :if => os[:family] == 'amazon' do

#unicorn
describe command('ps aux | grep unicorn') do
  its(:stdout) { should match /master/ }
end

#nginx
describe service('nginx') do
  it { should be_running }
end

#mysql
describe service('mysqld') do
  it { should be_running   }
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