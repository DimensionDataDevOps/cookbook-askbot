#
# Cookbook Name:: askbot
# Attributes:: solr
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

# Default haystack value == disabled; override with role/environment
default['askbot']['haystack']['enabled'] = nil

# solr requirements
default['askbot']['solr']['packages'] = ['python-dev', 'postgresql-server-dev-9.1', 'libldap2-dev', 'libsasl2-dev', 'memcached', 'libxml2-dev', 'libxslt-dev']
default['askbot']['solr']['version'] = '5.4.1'
default['askbot']['solr']['checksum'] = '3e4b4ec7bd728b49b2ebc3dbe8f3d1ef89fded4ab86b9e2f856bedd58c99f28b'

# Public URL to download solr
default['askbot']['solr']['url'] = "http://mirror.cogentco.com/pub/apache/lucene/solr/#{node['askbot']['solr']['version']}/solr-#{node['askbot']['solr']['version']}.tgz"

# Default solr version and url
default['askbot']['solr']['enabled'] = nil
default['askbot']['solr']['serverip'] = 'localhost'
default['askbot']['solr']['port'] = '8983'
