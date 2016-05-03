#
# Cookbook Name:: askbot
# Recipe:: solr
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
include_recipe 'solr'
include_recipe 'python::pip'

%w{ python-dev postgresql-server-dev-9.1 libldap2-dev libsasl2-dev memcached libxml2-dev libxslt-dev }.each do |pkg|
  package pkg
end

solr_instance_name = node['askbot']['environment']
solr_home = "/opt/solr/#{solr_instance_name}"
solr_schema = "#{solr_home}/conf/schema.xml"
solr_xml = "#{solr_home}/solr.xml"
solr_config = "#{solr_home}/conf/solrconfig.xml"

#Install solr related packages if solr == True
%w{pysolr lxml cssselect}.each do |pip|
  python_pip pip do
    action :install
  end
end

# solr_instance solr_instance_name do
#   path "/opt/solr"
#   action [:install, :create]
#   schema_is_dynamic true
# end

execute "build_solr_schema" do
  cwd node['askbot']['install']['dir']
  command "python manage.py build_solr_schema -f #{solr_schema}"
  action :run
  user "solr"
  only_if { ::File.exists?("#{solr_schema}/conf")}
end

{solr_xml => "solr.xml", solr_config => "solrconfig.xml"}.each do |template,src|
  template template do
    source "#{src}.erb"
    owner "solr"
    group "solr"
    mode "0755"
  end
end

# hax for bugs in dynamic schema
link "#{solr_home}/conf/stopwords_en.txt" do
  to "#{solr_home}/conf/stopwords.txt"
  #notifies :restart, "solr_instance[#{solr_instance_name}]", :immediately
end

# Install django-haystack 2.1.0 (default)
python_pip "django-haystack" do
  #version  "2.1.0"
  action :install
end