#
# Cookbook Name:: askbot
# Recipe:: mathjax
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'

if node['mathjax']['enabled']
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