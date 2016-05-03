#
# Cookbook Name:: askbot
# Attributes:: db
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

# Postgresql values
default['askbot']['db']['name'] = 'askbotdb'
default['askbot']['db']['user'] = 'askbotusr'
default['askbot']['db']['host'] = node['ipaddress']
default['askbot']['db']['port'] = 5432
default['askbot']['db']['askbot_passwd'] = nil
default['askbot']['db']['pgsql_passwd'] = nil

# Default Chef-Vault to retrieve Data Base creds
default['askbot']['db']['data_bag'] = node['askbot']['db']['name']
default['askbot']['db']['db_item'] = node['askbot']['db']['user']