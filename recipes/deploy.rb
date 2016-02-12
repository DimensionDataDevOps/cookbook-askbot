#
# Cookbook Name:: askbot
# Recipe:: deploy
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'apt'
include_recipe 'git'
include_recipe 'apache2'
include_recipe 'python::package'
#include_recipe 'python::pip'

%w{ python-dev postgresql-server-dev-9.3 libldap2-dev libsasl2-dev memcached libxml2-dev libxslt-dev python-pip libjpeg8-dev}.each do |pkg|
  package pkg
end

# Include and 'longerusername'
{"psycopg2" => "2.5.1", "python-ldap" => "2.4.13", "python-memcached" => "1.53"}.each do |pip,ver|
  python_pip pip do
    version ver
    action :install
  end
end

directory node['askbot']['install']['dir'] do
  mode 0775
  owner "root"
  group "root"
  action :create
end

%w{askbot askbot/upfiles log }.each do |dir|
  directory "#{node['askbot']['install']['dir']}/#{dir}" do
    owner "root"
    group "root"
    mode "1775"
    action :create
    recursive true
  end
end

file "#{node['askbot']['install']['dir']}/log/askbot.log" do
  owner 'root'
  group 'root'
  mode '0666'
  action :create
end

deploy node['askbot']['git']['dir'] do
  repo node['askbot']['git']['repository']
  revision node['askbot']['git']['revision']
  migrate false
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

#   before_restart do
#     execute "python install" do
#       cwd release_path
#       command "python setup.py install"
#       action :run
#     end

#     execute "askbot install" do
#       command "askbot-setup -v 2 -n #{node['askbot']['install']['dir']} -e 1 --force"
#       user "root"
#       group "root"
#       action :run
#       not_if { ::File.exists?("#{node['askbot']['install']['dir']}/settings.py")}
#     end

#     template "#{node['askbot']['install']['dir']}/settings.py" do
#       source "settings.py.erb"
#       owner "root"
#       group "root"
#       mode "0644"
#     end 

#     %w{ syncdb collectstatic }.each do |run|
#       execute "run #{run}" do
#         cwd node['askbot']['install']['dir']
#         command "python manage.py #{run} --noinput"
#         action :run
#       end
#     end

#     %w{ askbot django_authopenid robots longerusername djcelery group_messaging askbot.deps.django_authopenid }.each do |migrate|
#       execute "migrate #{migrate}" do
#         cwd node['askbot']['install']['dir']
#         command "python manage.py migrate #{migrate} --noinput"
#         action :run
#       end
#     end

#     # if node['solr']['enabled']
#     #   execute "build_solr_schema" do
#     #     cwd node['askbot']['install']['dir']
#     #     command "python manage.py build_solr_schema -f /opt/solr/#{node['askbot']['environment']}/conf/schema.xml"
#     #     action :run
#     #     only_if { ::File.exists?("/opt/solr/#{node['askbot']['environment']}/conf") }
#     #   end
#     # end
 
#     # if node['haystack']['enabled']
#     #   execute "rebuild_index" do
#     #     cwd node['askbot']['install']['dir']
#     #     command "python manage.py rebuild_index --noinput"
#     #     action :run
#     #     only_if { ::File.exists?("/opt/solr/#{node['askbot']['environment']}/conf") }
#     #   end

#     #   cron "haystack_update_index" do
#     #     minute "*/3"
#     #     action :create
#     #     command "/usr/bin/python #{node['askbot']['install']['dir']}/manage.py update_index > /dev/null 2>&1"
#     #     only_if { ::File.exists?("#{node['askbot']['install']['dir']}/manage.py")}
#     #   end
#     #end

#     logrotate_app "askbot" do
#       cookbook "logrotate"
#       path "#{node['askbot']['install']['dir']}/log/*.log"
#       frequency "daily"
#       rotate 14
#       create "664 root root"
#     end
#   end
# end
