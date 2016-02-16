#
# Cookbook Name:: askbot
# Recipe:: pgsql_install
#
# Copyright 2016, Dimension Data Cloud Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'askbot'

node.override['postgresql']['password']['postgres'] = node['askbot']['db']['pgsql_passwd']
node.override['postgresql']['config']['listen_addresses'] = '*'
node.override['postgresql']['pg_hba'] = [
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'trust'},
  {:comment => nil, :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:comment => nil, :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:comment => nil, :type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
  {:comment => '#"local" is for Unix domain socket connections only', :type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'peer'}
]

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

postgresql_connection_info = {
  :host => node['askbot']['db']['host'],
  :port => node['askbot']['db']['port'],
  :password => node['askbot']['db']['pgsql_passwd']
}

postgresql_database node['askbot']['db']['name'] do
  connection  postgresql_connection_info
  action :create
end

postgresql_database_user node['askbot']['db']['user'] do
  connection    postgresql_connection_info
  database_name node['askbot']['db']['name']
  password      node['askbot']['db']['askbot_passwd']
  action        :create
end

postgresql_database_user node['askbot']['db']['user'] do
  connection    postgresql_connection_info
  database_name node['askbot']['db']['name']
  privileges    [:all]
  action        :grant
end
