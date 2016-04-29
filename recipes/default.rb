#
# Cookbook Name:: askbot
# Recipe:: default
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

# Might have to switch this to a case loop to support platform_family? = rhel
unless !node['platform_family'] == 'debian'
  node.override['apt']['compile_time_update'] = true 

  include_recipe 'apt'
end

include_recipe 'chef-vault'

chef_gem 'chef-vault'
require 'chef-vault'

node.set['askbot']['db']['pgsql_passwd'] = chef_vault_item(node['askbot']['db']['data_bag'], 'postgresql')['passwordclear']
node.set['askbot']['db']['askbot_passwd'] = chef_vault_item(node['askbot']['db']['data_bag'], node['askbot']['db']['db_item'])['passwordclear']