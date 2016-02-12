#
# Cookbook Name:: askbot
# Recipe:: database
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

node.override['postgresql']['password']['postgres'] = 'password123'

include_recipe 'postgresql'
include_recipe 'database::postgresql'

postgresql_connection_info = {
  :host => node['hostname'],
  :port => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}


postgresql_database 'askbotdb' do
  connection  postgresql_connection_info
  action :create
end

postgresql_database_user 'askbotusr' do
  connection    postgresql_connection_info
  database_name 'askbotdb'
  password      'askbotpass123'
  action        :create
end

postgresql_database_user 'askbotusr' do
  connection    postgresql_connection_info
  database_name 'askbotdb'
  privileges    [:all]
  action        :grant
end