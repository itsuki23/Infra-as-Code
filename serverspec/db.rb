require 'spec_helper'


#describe package('    '), :if => os[:family] == 'amazon' do

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
