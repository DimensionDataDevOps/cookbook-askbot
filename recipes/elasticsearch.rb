#
# Cookbook Name:: askbot
# Recipe:: elasticsearch
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

include_recipe 'chef-sugar'
include_recipe 'python::pip'

['django-haystack', 'elasticsearch'].each do |pip_pkg|
  python_pip pip_pkg do
    action :install
  end
end

elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  type :package
end

elasticsearch_configure 'elasticsearch'

elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end