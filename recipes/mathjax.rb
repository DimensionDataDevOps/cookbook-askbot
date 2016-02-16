#
# Cookbook Name:: askbot
# Recipe:: mathjax
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

include_recipe 'git'

if !node['askbot']['mathjax']['enabled'].nil?
  deploy node['mathjax']['git']['dir'] do
    repo node['mathjax']['git']['repository']
    revision node['mathjax']['git']['revision']
    migrate false
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear

    before_restart do
      link "mathjax" do
        to "#{node['mathjax']['git']['dir']}/current"
        target_file "#{node['askbot']['install']['dir']}/static/mathjax"
        action :create
        only_if "test -L #{node['mathjax']['git']['dir']}/current"
      end
    end
  end
end