#
# Cookbook Name:: askbot
# Recipe:: web
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2'
include_recipe 'apache2::mod_wsgi'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_mime'
include_recipe 'apache2::mod_setenvif'
include_recipe 'apache2::mod_headers'

%w{ wsgi ssl rewrite deflate expires mime setenvif headers filter }.each do |mod|
  apache_module mod
end

%w{ askbot_443 askbot_80 }.each do |site|
  template "#{node['apache']['dir']}/sites-available/#{site}" do
    source "#{site}_apache.erb"
    owner "root"
    group "root"
    mode   0644
    notifies :restart, "service[apache2]"
  end

  web_app site do
    template "#{site}_apache.erb"
  end
end