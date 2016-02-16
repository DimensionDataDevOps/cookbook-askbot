#
# Cookbook Name:: askbot
# Recipe:: deploy
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
include_recipe 'git'
include_recipe 'apache2'
include_recipe 'python::package'
include_recipe 'python::pip'

%w{ python-dev postgresql-server-dev-9.3 libldap2-dev libsasl2-dev memcached libxml2-dev libxslt-dev python-pip libjpeg8-dev}.each do |pkg|
  package pkg
end

node['askbot']['pip']['packages'].each do |pip,ver|
  python_pip pip do
    version ver
    action :install
  end
end

deploy node['askbot']['git']['dir'] do
  repo node['askbot']['git']['repository']
  revision node['askbot']['git']['revision']
  migrate false
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear

  before_restart do

    [node['askbot']['install']['dir'],
    "#{node['askbot']['install']['dir']}/log",
    "#{node['askbot']['install']['dir']}/askbot",
    "#{node['askbot']['install']['dir']}/askbot/upfiles"].each do |dir|
      directory dir do
        owner 'www-data'
        group 'www-data'
        mode 1777
        action :create
        recursive true
      end
    end

    file "#{node['askbot']['install']['dir']}/log/askbot.log" do
      owner 'www-data'
      group 'www-data'
      mode 1777
      action :create
    end

    execute 'python install' do
     cwd release_path
     command "python setup.py install"
     action :run
    end
    
    execute 'askbot install' do
     command "askbot-setup -v 2 -n #{node['askbot']['install']['dir']} -e 1 --force"
     user 'www-data'
     group 'www-data'
     action :run
     not_if {::File.exists?("#{node['askbot']['install']['dir']}/settings.py")}
    end

    template "#{node['askbot']['install']['dir']}/settings.py" do
      source 'settings.py.erb'
      variables({
        :ADMIN_NAME => node['askbot']['admin_name'],
        :ADMIN_EMAIL => node['askbot']['admins_email'],
        :DB_NAME => node['askbot']['db']['name'],
        :DB_USR => node['askbot']['db']['user'],
        :DB_PASSWD => node['askbot']['db']['askbot_passwd'],
        :DB_HOST => node['askbot']['db']['host'],
        :DB_PORT => node['askbot']['db']['port'],
        :SMTP_HOST => node['askbot']['smtp']['host'],
        :SMTP_USR => node['askbot']['smtp']['user'],
        :SMTP_PASSWD => node['askbot']['smtp']['passwd'],
        :MEMCACHE_HOST => node['askbot']['memcache']['host']
      })
    end

    ['syncdb', 'collectstatic'].each do |run|
      execute "run #{run}" do
        cwd node['askbot']['install']['dir']
        command "python manage.py #{run} --noinput"
        action :run
      end
    end
  end
end

#     template "#{node['askbot']['install']['dir']}/settings.py" do
#       source "settings.py.erb"
#       owner "root"
#       group "root"
#       mode "0644"
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
