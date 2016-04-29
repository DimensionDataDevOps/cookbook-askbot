#
# Cookbook Name:: askbot
# Recipe:: web
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
include_recipe 'apache2'
include_recipe 'apache2::mod_wsgi'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_mime'
include_recipe 'apache2::mod_setenvif'
include_recipe 'apache2::mod_headers'

directory "/var/www" do
  owner 'www-data'
  group 'www-data'
  mode 0777
end

# Loop through apache mods
%w{ wsgi ssl rewrite deflate expires mime setenvif headers filter }.each do |mod|
  apache_module mod
end

# Deploy template via web_app resource
%w{ askbot_443 askbot_80 }.each do |site|
  web_app site do
    template "#{site}_apache.erb"
  end
end