require 'spec_helper'

describe 'hiera' do
  let (:facts) {{ :operatingsystem => 'debian' }}

  context 'with puppet enterprise and default parameters' do
    let (:facts) {{ :puppetversion => 'Puppet Enterprise' }}
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppetlabs/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppetlabs/puppet/hiera.yaml',
      })
    end
  end

  context 'with puppet community edition and default parameters' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppet/hiera.yaml',
      })
    end

    it 'uses the yaml backend by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{:backends:\n  - yaml\n:logger:})
    end

    it 'uses an empty hierarchy by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{:hierarchy:\n\n:yaml:})
    end
  end

  context 'with custom backend configuration' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :backends => [ {'foo' => { 'bar' => 'baz' }} ],
    }}

    it 'properly configures the given backends' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{:foo:\n  :bar: baz\n})
    end
  end

  context 'with custom hierarchy configuration' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :hierarchy => [ 'bla', 'sausage' ],
    }}

    it 'properly configures the given backends' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{:hierarchy:\n  - bla\n  - sausage\n:yaml:})
    end
  end
end
