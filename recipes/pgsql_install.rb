#
# Cookbook Name:: askbot
# Recipe:: pgsql_install
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

node.override['postgresql']['password']['postgres'] = 'password123'
node.override['postgresql']['config']['listen_addresses'] = '*'
node.override['postgresql']['pg_hba'] = [
  {:comment => nil, :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:comment => nil, :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'trust'},
  {:comment => '# "local" is for Unix domain socket connections only', :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'peer'}
]

include_recipe 'postgresql::server'