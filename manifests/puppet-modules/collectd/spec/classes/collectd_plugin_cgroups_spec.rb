require 'spec_helper'

describe 'collectd::plugin::cgroups', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '5.4.0',
      operatingsystemmajrelease: '7',
      python_dir: '/usr/local/lib/python2.7/dist-packages'
    }
  end
  context ':ensure => present, default params' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4.0',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end
    it 'Will create /etc/collectd.d/10-cgroups.conf' do
      is_expected.to contain_file('cgroups.load').
        with(ensure: 'present',
             path: '/etc/collectd.d/10-cgroups.conf',
             content: %r{# Generated by Puppet\n<LoadPlugin cgroups>\n  Globals false\n</LoadPlugin>\n\n<Plugin cgroups>\n  IgnoreSelected false\n</Plugin>})
    end
  end

  context ':ensure => present, specific params, collectd version 5.4.0' do
    let :facts do
      {
        osfamily: 'Redhat',
        collectd_version: '5.4.0',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end
    let :params do
      {
        cgroups: ['/var/lib/test1', '/var/lib/test2'],
        ensure: 'present',
        ignore_selected: true
      }
    end

    it 'Will create /etc/collectd.d/10-cgroups.conf for collectd >= 5.4' do
      is_expected.to contain_file('cgroups.load').
        with(ensure: 'present',
             path: '/etc/collectd.d/10-cgroups.conf',
             content: %r{# Generated by Puppet\n<LoadPlugin cgroups>\n  Globals false\n</LoadPlugin>\n\n<Plugin cgroups>\n  CGroup "/var/lib/test1"\n  CGroup "/var/lib/test2"\n  IgnoreSelected true\n</Plugin>})
    end
  end

  context ':ensure => absent' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5.0',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end

    let :params do
      { ensure: 'absent' }
    end

    it 'Will not create /etc/collectd.d/10-cgroups.conf' do
      is_expected.to contain_file('cgroups.load').
        with(ensure: 'absent',
             path: '/etc/collectd.d/10-cgroups.conf')
    end
  end
end
