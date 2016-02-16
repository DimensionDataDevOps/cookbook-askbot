#
# Cookbook Name:: askbot
# Attributes:: default
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

# Default environment
default['askbot']['environment'] = 'askbot_testing'

# Admin attributes
default['askbot']['admin_name'] = 'Askbot Admin'
default['askbot']['admins_email'] = 'admin@domain.com'
default['askbot']['from_email'] = node['askbot']['admins_email'] 
default['askbot']['smtp'] = '127.0.0.1'

# Hash of pip packages to install
default['askbot']['pip']['packages'] = {
  "psycopg2" => "2.5.1",
  "python-ldap" => "2.4.25",
  "python-memcached" => "1.57",
  "longerusername" => "0.4"
}

# Default to clone from github.com and master branch
default['askbot']['git']['dir'] = '/opt/askbot'
default['askbot']['git']['repository'] = 'https://github.com/ASKBOT/askbot-devel.git'
default['askbot']['git']['revision'] = 'master'

# Defines install dir; depends on environment ( dev/prod). Default 'testing'
default['askbot']['install']['dir'] = "/srv/#{node['askbot']['environment']}"

# Postgresql values
default['askbot']['db']['name'] = 'askbotdb'
default['askbot']['db']['user'] = 'askbotusr'
default['askbot']['db']['host'] = node['ipaddress']
default['askbot']['db']['port'] = 5432

# Default Chef-Vault to retrieve Data Base creds
default['askbot']['db']['data_bag'] = node['askbot']['db']['name']
default['askbot']['db']['db_item'] = node['askbot']['db']['user']